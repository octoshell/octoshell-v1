class Task < ActiveRecord::Base
  has_paper_trail
  
  PROCEDURES = %w(
    add_user
    block_user
    unblock_user
    del_user
    add_openkey
    del_openkey
  )
  
  belongs_to :resource, polymorphic: true
  
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
    
    event :_force_success do
      transition [:failed, :pending] => :successed
    end
    
    event :_failure do
      transition pending: :failed
    end
  end
  
  define_defaults_events :success, :failure, :force_success
  
  define_state_machine_scopes
  
  def self.setup(procedure)
    transaction do
      task = scoped.create! do |task|
        task.procedure = procedure
        task.assign_command
      end
      Resque.enqueue TasksWorker, task.id
    end
  end
  
  def perform
    return unless pending?
    status = Timeout::timeout(10) do
      execute!
    end
  rescue Timeout::Error
    self.stderr = 'Timeout::Error'
    failure!
  end
  
  def retry
    self.class.new do |task|
      task.procedure = procedure
      task.resource  = resource
      task.command   = command
    end
  end
  
  def retry!
    save and Resque.enqueue(TasksWorker, id)
  end
  
  def procedure_string
    procedure.to_s
  end
  
  def success!
    transaction do
      validate_errors
      if errors.empty?
        _success!
        resource.continue!(procedure)
      else
        failure!
      end
    end
  end
  
  def force_success!
    transaction do
      _force_success!
      resource.continue!(procedure)
    end
  end

  def failure!
    transaction do
      if _failure
        resource.stop!(procedure)
        # UserMailer.report_failed_task(self)
      else
        raise self.errors.inspect
      end
    end
  end
  
  def assign_command
    template = resource.cluster.send(procedure)
    procedure_replacement.each do |key, value|
      template.gsub! "%#{key}%", %{"#{value}"}
    end
    
    self.command = template
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
    end
  end
  
  def execute!
    exec = command.gsub '"', '\"'
    
    Open3.popen3(%{bash -c "#{exec}"}) do |stdin, stdout, stderr|
      self.stderr = stderr.read
      self.stdout = stdout.read
    end
    success!
  rescue => e
    self.stderr ||= e.message
    failure!
  end
  
  def validate_errors
    errors.add(:command) unless command?
    errors.add(:base, :failed) if stdout? || stderr?
  end
end
