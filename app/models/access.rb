class Access < ActiveRecord::Base
  belongs_to :project
  belongs_to :credential
  belongs_to :cluster
  
  validates :project, :credential, :cluster, presence: true
  validates :project_id, uniqueness: { scope: [:credential_id, :cluster_id] }
  
  after_create :get_access
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :failed
    
    event :_activate do
      transition pending: :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_failure do
      transition active: :finished
    end
  end
  
  %w(activate decline finish).each do |event|
    define_method event do
      send "_#{event}"
    end

    define_method "#{event}!" do
      send "_#{event}!"
    end
  end
  
  def continue!(procedure)
    method = "continue_#{procedure}"
    send(method) if respond_to?(method)
  end
  
private
  
  def get_access
    tasks.setup(:add_openkey)
  end
  
  def continue_add_openkey
    activate!
  end
end
