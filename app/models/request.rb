class Request < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :persisted?, :state_name, to: :project, prefix: true, allow_nil: true
  delegate :state_name, to: :cluster, prefix: true, allow_nil: true
  delegate :state_name, to: :user, prefix: true, allow_nil: true
  
  has_many :request_properties
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
  attr_accessible :hours, :cluster_id, :project_id, :user_id, :size, :request_properties_attributes, as: :admin
  
  accepts_nested_attributes_for :request_properties
  
  after_create :create_request_properties
  
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
  
private
  
  def create_request_properties
    cluster.cluster_fields.each do |cluster_field|
      request_properties.create! do |request_property|
        request_property.name = cluster_field.name
      end
    end
  end
end
