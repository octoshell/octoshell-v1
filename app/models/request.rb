class Request < ActiveRecord::Base
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  
  validates :project, :cluster, :hours, :user, presence: true
  
  attr_accessible :hours, :cluster_id
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :finished
    
    event :_activate do
      transition pending: :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_finish do
      transition active: :finished
    end
  end
  
  def activate
    _activate
  end
  
  def decline
    _decline
  end
  
  def finish
    _finish
  end
end
