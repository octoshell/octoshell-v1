class Access < ActiveRecord::Base
  belongs_to :project
  belongs_to :credential
  belongs_to :cluster
  has_many :tasks, as: :resource
  
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
  
  define_defaults_events :activate, :decline, :failure
  
  def continue!(procedure)
    method = "continue_#{procedure}"
    send(method) if respond_to?(method)
  end
  
  def stop!(procedure)
    failure!
  end
  
protected
  
  def continue_add_openkey
    activate!
  end
  
  def continue_del_openkey
    delete
  end
  
private
  
  def get_access
    tasks.setup(:add_openkey)
    true
  end
end
