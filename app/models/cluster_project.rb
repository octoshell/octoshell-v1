class ClusterProject < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  include Models::MarkableForTask
  
  default_scope order("#{table_name}.id desc")
  
  belongs_to :project
  belongs_to :cluster
  has_many :cluster_users, dependent: :destroy
  has_many :tasks, as: :resource, dependent: :destroy
  has_many :requests, dependent: :destroy
  
  validates :project, :cluster, presence: true
  
  attr_accessible :project_id, :cluster_id, :username, :state, as: :admin
  
  before_create :assign_username
  
  state_machine initial: :closed do
    state :closed
    state :activing
    state :active
    state :pausing
    state :paused
    state :closing
    
    event :activate do
      transition [:closed, :paused] => :activing
    end
    
    event :complete_activation do
      transition :activing => :active
    end
    
    event :pause do
      transition :active => :pausing
    end
    
    event :complete_pausing do
      transition :pausing => :paused
    end
    
    event :close do
      transition [:active, :paused] => :closing
    end
    
    event :complete_closure do
      transition :closing => :closed
    end
    
    around_transition :on => [:activate, :pause] do |cp, _, block|
      cp.transaction do
        cp.check_process!
        block.call
        cp.mark_for_task!
      end
    end
    
    around_transition :on => :close do |cp, _, block|
      cp.transaction do
        cp.check_process!
        block.call
        cp.cluster_users.non_closed.each &:force_close!
        cp.mark_for_task!
      end
    end
    
    around_transition :on => :complete_activation do |cp, _, block|
      cp.transaction do
        block.call
        cp.create_possible_accounts!
        cp.activate_non_active_cluster_users!
      end
    end
  end
  define_state_machine_scopes
  
  def check_process!
    if [:activing, :pausing, :closing].include?(state_name)
      raise ActiveRecord::RecordInProcess
    end
  end
  
  def accesses
    Access.where(cluster_user_id: cluster_user_ids)
  end
  
  def has_active_entities?
    !closed? || cluster_users.any?(&:has_active_entities?)
  end
  
  def to_s
    username
  end

  def link_name
    username
  end
  
  def create_possible_accounts!
    project.accounts.each do |account|
      cluster_users.where(account_id: account.id).first_or_create!
    end
  end
  
  def activate_non_active_cluster_users!
    cluster_users.non_active.joins(:account).where(
      accounts: { state: 'active' }
    ).includes(:account).each &:activate!
  end
  
protected
  
  def continue_add_project(task)
    complete_activation!
  end
  
  def continue_del_project(task)
    complete_closure!
  end
  
  def continue_block_project(task)
    complete_pausing!
  end
  
  def continue_unblock_project(task)
    complete_activation!
  end

private
  
  def assign_username
    self.username ||= project.login
    true
  end
end
