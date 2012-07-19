class Task < ActiveRecord::Base
  PROCEDURES = %w(
    add_user
    block_user
    del_user
    add_openkey
    del_openkey
  )
  
  belongs_to :resource, polymorphic: true
  
  validates :resource, :procedure, presence: true
  validates :command, presence: true, on: :update
  validates :procedure_string, inclusion: { in: PROCEDURES }
  
  state_machine initial: :pending do
    state :pending
    state :successed do
      validate :no_errors
    end
    state :failed
    
    event :_success do
      transition pending: :successed
    end
    
    event :_failure do
      transition pending: :failed
    end
  end
  
  define_defaults_events :success, :failure
  
  def self.setup(procedure)
    transaction do
      task = scoped.create! do |task|
        task.procedure = procedure
      end
      Resque.enqueue TasksWorker, task.id
    end
  end
  
  def success!
    if _success
      resource.continue!(procedure)
    else
      failure!
    end
  end
  
  def failure!
    if _failure
      resource.stop!(procedure)
      # UserMailer.report_failed_task(self)
    else
      raise self.errors.inspect
    end
  end
  
  def perform
    return unless pending?
    send procedure
  end
  
  def procedure_string
    procedure.to_s
  end
  
private
  
  # /usr/local/bin/add_user host project_1
  # resource is a request
  def add_user
    args = []
    args << resource.cluster.host
    args << resource.project.username
    execute bin('add_user'), *args
  end
  
  # # /usr/local/bin/block_user host project_1
  # def block_user
  #   args = []
  #   args << resource.cluster.host
  #   args << resource.project.username
  #   execute bin('block_user'), *args
  # end
  
  # /usr/local/bin/del_user host project_1
  # resource is a request
  def del_user
    args = []
    args << resource.cluster.host
    args << resource.project.username
    execute bin('del_user'), *args
  end
  
  # /usr/local/bin/add_openkey host project_1 key
  # resource is an access
  def add_openkey
    args = []
    args << resource.cluster.host
    args << resource.project.username
    args << resource.public_key
    execute bin('add_openkey'), *args
  end
  
  # /usr/local/bin/del_openkey host project_1 key
  # resource is an access
  def del_openkey
    args = []
    args << resource.cluster.host
    args << resource.project.username
    args << data[:public_key]
    execute bin('del_openkey'), *args
  end
  
  def execute(*args)
    self.command = args.join ' '
    Open3.popen3(args.pop, args.join(' ')) do |stdin, stdout, stderr|
      self.stderr = stderr.read
      self.stdout = stdout.read
    end
    success!
  rescue => e
    self.stderr ||= e.message
    failure!
  end
  
  def bin(exe)
    "/usr/local/bin/#{exe}"
  end
  
  def no_errors
    errors.add(:base, :failed)
  end
end
