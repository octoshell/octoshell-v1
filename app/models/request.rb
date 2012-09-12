class Request < ActiveRecord::Base
  attr_accessor :cluster_id, :project_id
  
  delegate :cluster_users, :cluster, :project,
    to: :cluster_project, allow_nil: true
  
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  has_many :request_properties
  belongs_to :user
  belongs_to :cluster_project
  
  validates :cluster_project, :hours, :user, :size, presence: true
  validates :cluster_id, :project_id, presence: true, unless: :cluster_project
  validates :size, :hours, numericality: { greater_than: 0 }
  validates :state, uniqueness: { scope: [:cluster_project_id] }, if: :active?
  
  attr_accessible :hours, :cluster_id, :project_id, :size
  attr_accessible :hours, :cluster_id, :project_id, :user_id, :size, :request_properties_attributes, as: :admin
  
  accepts_nested_attributes_for :request_properties
  
  before_validation :assign_cluster_project, on: :create
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
      transition [:pending, :active, :declined] => :closed
    end
    
    event :_force_close do
      transition [:pending, :active, :declined] => :closed
    end
  end
  
  define_defaults_events :activate, :decline, :close, :force_close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      cluster_project.check_process!
      cluster_project.pause! if cluster_project.active?
      cluster_project.close! if cluster_project.paused?
    end
  end
  
  def activate!
    transaction do
      _activate!
      cluster_project.check_process!
      cluster_project.activate!
    end
  end
  
  def allowed_projects
    user ? user.owned_projects.active : []
  end
  
  def task_attributes
    attributes = { hours: hours, size: size }
    
    if request_properties.any?
      properties =
        Hash[request_properties.map do |property|
          [property.name.to_sym, property.value]
        end]
      attributes.merge! properties
    end
    
    attributes
  end
  
private
  
  def assign_cluster_project
    conditions = { cluster_id: cluster_id, project_id: project_id }
    self.cluster_project ||= ClusterProject.where(conditions).first
  end
  
  def create_request_properties
    cluster.cluster_fields.each do |cluster_field|
      request_properties.create! do |request_property|
        request_property.name = cluster_field.name
      end
    end
  end
end
