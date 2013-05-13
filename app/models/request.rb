# coding: utf-8
class Request < ActiveRecord::Base
  include Models::Limitable
  
  delegate :accounts, :user, to: :project
  
  has_paper_trail
  
  has_many :request_properties
  belongs_to :project
  belongs_to :cluster
  
  validates :cpu_hours, :gpu_hours, :size, presence: true
  validates :cluster, :project, presence: true
  validates :size, :cpu_hours, :gpu_hours, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :cpu_hours, :gpu_hours, :size, :project_id, :cluster_id
  
  accepts_nested_attributes_for :request_properties
  
  after_create :create_request_properties
  after_create :set_default_group_name, unless: :group_name?
  
  scope :last_pending, where(state: 'pending').order('id desc')
  scope :maintaining, where("#{table_name}.maintain_requested_at is not null")
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :blocked
    state :declined
    state :closed
    
    event :activate do
      transition :pending => :active
    end

    event :decline do
      transition :pending => :declined
    end
    
    event :close do
      transition [:pending, :active, :blocked, :declined] => :closed
    end
    
    event :block do
      transition :active => :blocked
    end
    
    event :unblock do
      transition :blocked => :active
    end
    
    inside_transition :on => [:activate, :block, :unblock, :close] do |r|
      r.request_maintain!
    end
  end
  
  def allowed_projects
    user ? user.owned_projects.with_states(:active, :blocked, :announced) : []
  end
  
  def request_maintain!
    touch :maintain_requested_at
  end
  
  def complete_maintain!
    update_column :maintain_requested_at, nil
  end
  
  def link_name
    "Заявка ##{id}"
  end
  
private
  
  def set_default_group_name
    update_column :group_name, "project_#{project_id}"
  end
  
  def create_request_properties
    cluster.cluster_fields.each do |cluster_field|
      request_properties.create! do |request_property|
        request_property.name = cluster_field.name
      end
    end
  end
end
