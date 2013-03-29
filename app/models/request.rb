# coding: utf-8
class Request < ActiveRecord::Base
  include Models::Limitable
  
  attr_accessor :cluster_id, :project_id
  
  delegate :cluster_users, :cluster, :project,
    to: :cluster_project, allow_nil: true
  
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  has_many :request_properties
  belongs_to :user
  belongs_to :cluster_project
  
  validates :cluster_project, :cpu_hours, :gpu_hours, :user, :size, presence: true
  validates :cluster_id, :project_id, presence: true, unless: :cluster_project
  validates :size, :cpu_hours, :gpu_hours, numericality: { greater_than_or_equal_to: 0 }
  validates :state, uniqueness: { scope: [:cluster_project_id], message: 'не уникален. Активная заявка уже существует' }, if: :active?
  
  attr_accessible :cpu_hours, :gpu_hours, :cluster_id, :project_id, :size
  
  accepts_nested_attributes_for :request_properties
  
  before_validation :assign_cluster_project, on: :create
  after_create :create_request_properties
  after_save :revalidate_project
  
  scope :last_pending, where(state: 'pending').order('id desc')
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :paused
    state :declined
    state :closed
    
    event :_activate do
      transition [:pending, :paused] => :active
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
    
    event :pause do
      transition :active => :paused
    end
  end
  
  define_defaults_events :activate, :decline, :close, :force_close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      cluster_project.pause! if cluster_project.active?
      cluster_project.close! if cluster_project.paused?
    end
    true
  end
  
  def activate
    activate!
  rescue => e
    false
  end
  
  def activate!
    transaction do
      _activate!
      cluster_project.activate!
    end
    true
  end
  
  def allowed_projects
    user ? user.owned_projects.with_states(:active, :blocked, :announced) : []
  end
    
private
  
  def assign_cluster_project
    conditions = { cluster_id: cluster_id, project_id: project_id }
    self.cluster_project = ClusterProject.where(conditions).first_or_create!
  end
  
  def create_request_properties
    cluster.cluster_fields.each do |cluster_field|
      request_properties.create! do |request_property|
        request_property.name = cluster_field.name
      end
    end
  end

  def link_name
    "Request #{id}"
  end
  
  def revalidate_project
    project.revalidate!
  end
end
