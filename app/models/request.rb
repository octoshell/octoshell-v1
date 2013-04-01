# coding: utf-8
class Request < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  has_many :request_properties
  belongs_to :user
  
  validates :cpu_hours, :gpu_hours, :user, :size, presence: true
  validates :cluster_id, :project_id, presence: true, unless: :cluster_project
  validates :size, :cpu_hours, :gpu_hours, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :cpu_hours, :gpu_hours, :cluster_id, :project_id, :size
  
  accepts_nested_attributes_for :request_properties
  
  after_create :create_request_properties
  after_save :revalidate_project
  
  scope :last_pending, where(state: 'pending').order('id desc')
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :paused
    state :declined
    state :closed
    
    event :activate do
      transition [:pending, :paused] => :active
    end

    event :decline do
      transition :pending => :declined
    end
    
    event :close do
      transition [:pending, :active, :declined] => :closed
    end
    
    event :force_close do
      transition [:pending, :active, :declined] => :closed
    end
    
    event :pause do
      transition :active => :paused
    end
  end
  
  def allowed_projects
    user ? user.owned_projects.with_states(:active, :blocked, :announced) : []
  end
    
private
  
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
