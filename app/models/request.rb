class Request < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :persisted?, :state_name, to: :project, prefix: true, allow_nil: true
  delegate :state_name, to: :cluster, prefix: true, allow_nil: true
  delegate :state_name, to: :user, prefix: true, allow_nil: true
  
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  
  validates :project, :cluster, :hours, :user, :size, presence: true
  validates :project, inclusion: { in: proc(&:allowed_projects) },
    on: :create, if: :project_persisted?
  validates :size, :hours, numericality: { greater_than: 0 }
  
  validates :cluster_state_name, exclusion: { in: [:closed] }, on: :create
  validates :user_state_name, inclusion: { in: [:sured] }, on: :create
  validates :project_state_name, inclusion: { in: [:active] }, on: :create
  
  attr_accessible :hours, :cluster_id, :project_id, :size
  attr_accessible :hours, :cluster_id, :project_id, :user_id, :size, as: :admin
  
  scope :last_pending, where(state: 'pending').order('id desc')
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :closed
    
    event :_activate do
      transition pending: :active
    end

    event :_decline do
      transition pending: :declined
    end
    
    event :_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :decline, :close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      ClusterUser.pause_for(project_id, cluster_id)
    end
  end
  
  def activate!
    transaction do
      _activate!
      ClusterUser.activate_for(project_id, cluster_id)
    end
  end
  
  def allowed_projects
    user ? user.owned_projects.active : []
  end
  
  def cluster_users
    conditions = { project_id: project_id, cluster_id: cluster_id }
    ClusterUser.where(conditions)
  end
end
