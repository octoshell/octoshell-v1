# coding: utf-8
# Модель доступа человека к проекту
class Account < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :state_name, to: :user, prefix: true, allow_nil: true
  delegate :state_name, to: :project, prefix: true, allow_nil: true
  
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  has_many :cluster_users, autosave: true, dependent: :destroy
  
  validates :user, :project, presence: true
  validates :username, presence: true, on: :update
  
  attr_accessible :user_id
  attr_accessible :project_id, :user_id, :username, as: :admin
  
  scope :by_params, proc { |p| where(project_id: p[:project_id], user_id: p[:user_id]) }
  
  after_create :assign_username
  
  state_machine initial: :closed do
    state :closed
    state :active
    
    event :_activate do
      transition closed: :active
    end
    
    event :_cancel do
      transition active: :closed
    end
  end
  
  define_defaults_events :activate, :cancel
  
  define_state_machine_scopes
  
  def activate
    if user.ready_to_activate_account?
      activate!
    else
      errors.add(:base, :not_ready_to_be_activated)
      false
    end
  end
  
  def activate!
    transaction do
      _activate!
      
      project.cluster_projects.each do |cp|
        cluster_users.where(cluster_project_id: cp.id).first_or_create!
      end
      
      cluster_users.joins(:cluster_project).where(
        cluster_projects: { state: 'active' }
      ).includes(:cluster_project).each &:activate!
    end
  end
  
  def cancel!
    transaction do
      _cancel!
      cluster_users(true).non_closed.each &:close!
    end
  end
  
  def accesses
    Access.where(
      credential_id:   user.credential_ids,
      cluster_user_id: cluster_user_ids
    )
  end
  
  def username=(username)
    self[:username] = username
    cluster_users.each { |cu| cu.username = username }
  end
  
  def to_s
    username
  end

  def login
    "#{project.project_prefix}#{username}"
  end
  
private
  
  def assign_username
    username = 
      if project.cluster_user_type == 'account'
        "#{user.username}_#{id}"
      else
        project.login
      end
    update_attribute :username, username
  end
end
