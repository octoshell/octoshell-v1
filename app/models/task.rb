class Task < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  PROCEDURES = %w(
    add_user
    block_user
    unblock_user
    del_user
    add_openkey
    del_openkey
    get_statistic
  )
  
  belongs_to :resource, polymorphic: true
  belongs_to :task
  has_many :tasks
  
  validates :resource, :command, :procedure, presence: true
  validates :procedure_string, inclusion: { in: PROCEDURES }
  
  attr_accessible :command, :procedure, :resource_type, :resource_id,
    as: :admin
  
  PROCEDURES.each do |proc|
    scope proc.to_sym, where(procedure: proc)
  end
  
  state_machine initial: :pending do
    state :pending
    state :successed
    state :failed
    
    event :_success do
      transition pending: :successed
    end
    
    event :_failure do
      transition pending: :failed
    end
  end
  
  define_defaults_events :success, :failure
  
  define_state_machine_scopes
  
  def self.setup(procedure)
    transaction do
      task = scoped.create! do |task|
        task.procedure = procedure
        task.assign_command
      end
      Resque.enqueue TasksWorker, task.id
      task
    end
  end
  
  def self.human_resource_types
    @human_resource_types ||= 
      unscoped.select(:resource_type).uniq.map(&:resource_type).map do |klass|
        [klass.constantize.model_name.human, klass]
      end
  end
  
  def perform
    return unless pending?
    
    Timeout::timeout(10) { execute! }
    
    if succeed_command?
      success!
      perform_callbacks!
    else
      failure!
    end
  rescue Timeout::Error
    self.comment = 'Timeout::Error'
    failure!
  rescue => e
    self.comment = e.to_s
    failure!
  end
    
  def retry(attributes, options = {})
    task = tasks.build(attributes, options)
    task.save and Resque.enqueue(TasksWorker, id)
  end
  
  def procedure_string
    procedure.to_s
  end
  
  def assign_command
    template = resource.cluster.send(procedure)
    procedure_replacement.each do |key, value|
      template.gsub! "%#{key}%", %{"#{value}"}
    end
    
    self.command = template
  end
  
  def can_perform_callbacks?
    not callbacks_performed?
  end
  
  def perform_callbacks!
    return true unless can_perform_callbacks?
    
    transaction do
      self.callbacks_performed = true
      resource.continue!(procedure, self)
      save!
    end
  rescue StateMachine::InvalidTransition => e
    errors.add(:base, e.to_s)
    false
  rescue => e
    errors.add(:base, e.to_s)
    false
  end
  
  def description
    I18n.t("tasks.description.#{procedure}.html").html_safe
  end
  
private
  
  def procedure_replacement
    case procedure.to_sym
    when :add_user, :del_user, :block_user, :unblock_user then
      { user: resource.project.username,
        host: resource.cluster.host }
    when :add_openkey, :del_openkey then
      { user:       resource.cluster_user.project.username,
        host:       resource.cluster.host,
        public_key: resource.credential.public_key }
    when :get_statistic then
      { host: resource.host }
    end
  end
  
  def execute!
    exec = command.gsub '"', '\"'
    Open3.popen3(%{bash -c "#{exec}"}) do |stdin, stdout, stderr|
      self.stderr = stderr.read
      self.stdout = stdout.read
    end
  end
  
  def succeed_command?
    !stderr?
  end
end
