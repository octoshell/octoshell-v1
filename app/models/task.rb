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
  
  validates :resource, :procedure, presence: true
  validates :procedure_string, inclusion: { in: PROCEDURES }
  
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
      end
      Resque.enqueue TasksWorker, task.id
    end
  end
  
  def perform
    return unless pending?
    send procedure
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
  
private
  
  def add_user
    execute :add_user, {
      user: resource.project.username,
      host: resource.cluster.host
    }
  end
  
  def del_user
    execute :del_user, {
      user: resource.project.username,
      host: resource.cluster.host
    }
  end
  
  def block_user
    execute :block_user, {
      user: resource.project.username,
      host: resource.cluster.host
    }
  end
  
  def unblock_user
    execute :unblock_user, {
      user: resource.project.username,
      host: resource.cluster.host
    }
  end
  
  def add_openkey
    execute :add_openkey, {
      user:       resource.cluster_user.project.username,
      host:       resource.cluster.host,
      public_key: resource.credential.public_key
    }
  end
  
  def del_openkey
    execute :del_openkey, {
      user:       resource.cluster_user.project.username,
      host:       resource.cluster.host,
      public_key: resource.credential.public_key
    }
  end
  
  def execute(cmd, replacement = {})
    template = resource.cluster.send(cmd)
    replacement.each do |key, value|
      template.gsub! "%#{key}%", %{"#{value}"}
    end
    
    self.command = template
    
    template.gsub! '"', '\"'
    
    Open3.popen3(%{bash -c "#{template}"}) do |stdin, stdout, stderr|
      self.stderr = stderr.read
      self.stdout = stdout.read
    end
    success!
  rescue => e
    self.stderr ||= e.message
    failure!
  end
  
  def bin(cmd)
    template = resource.cluster.send(cmd)
    "#{Rails.root}/script/#{exe}"
  end
  
  def validate_errors
    errors.add(:command) unless command?
    errors.add(:base, :failed) if stdout? || stderr?
  end
end
