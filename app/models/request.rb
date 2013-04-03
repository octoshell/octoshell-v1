# coding: utf-8
class Request < ActiveRecord::Base
  include Models::Limitable
  
  delegate :accounts, to: :project
  
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  has_many :request_properties
  belongs_to :project
  belongs_to :cluster
  
  validates :cpu_hours, :gpu_hours, :size, presence: true
  validates :cluster, :project, presence: true
  validates :size, :cpu_hours, :gpu_hours, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :cpu_hours, :gpu_hours, :cluster_id, :project_id, :size
  
  accepts_nested_attributes_for :request_properties
  
  after_create :create_request_properties
  
  scope :last_pending, where(state: 'pending').order('id desc')
  
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
    
    inside_transition :on => :activate do |r|
      r.accounts.without_cluster_state(:active).each &:activate!
    end
    
    inside_transition :on => :block do |r|
      r.accounts.with_cluster_state(:active).each &:block!
    end
    
    inside_transition :on => :unblock do |r|
      r.accounts.with_cluster_state(:blocked).each &:unblock!
    end
    
    inside_transition :on => :close do |r|
      r.accounts.without_cluster_states(:blocked, :closed).each &:block!
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
end
