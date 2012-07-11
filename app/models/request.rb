class Request < ActiveRecord::Base
  delegate :persisted?, to: :project, prefix: true
  
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  
  validates :project, :cluster, :hours, :user, presence: true
  validates :project, inclusion: { in: proc(&:allowed_projects) },
    on: :create, if: :project_persisted?
  
  attr_accessible :hours, :cluster_id, :project_id
  
  scope :last_pending, where(state: 'pending').order('id desc')
  
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
  
  def allowed_projects
    if user
      user.projects
    else
      []
    end
  end
end
