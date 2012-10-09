class ClusterProject < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  
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
    
    event :_activate do
      transition [:closed, :paused] => :activing
    end
    
    event :_complete_activation do
      transition activing: :active
    end
    
    event :_pause do
      transition active: :pausing
    end
    
    event :_complete_pausing do
      transition pausing: :paused
    end
    
    event :_close do
      transition [:active, :paused] => :closing
    end
    
    event :_complete_closure do
      transition closing: :closed
    end
  end
  
  define_defaults_events :activate, :complete_activation, :close,
    :complete_closure, :complete_pausing, :pause
  
  define_state_machine_scopes
  
  def activate!
    check_process!
    
    transaction do
      procedure = closed? ? :add_project : :unblock_project
      _activate!
      tasks.setup(procedure)
    end
  end
  
  def pause!
    check_process!
    
    transaction do
      _pause!
      tasks.setup(:block_project)
    end
  end
  
  def close!
    check_process!
    
    transaction do
      _close!
      cluster_users.non_closed.each &:force_close!
      tasks.setup(:del_project)
    end
  end
  
  def complete_activation!
    transaction do
      _complete_activation!
      
      project.accounts.each do |account|
        cluster_users.where(account_id: account.id).first_or_create!
      end
      
      cluster_users.non_active.joins(:account).where(
        accounts: { state: 'active' }
      ).includes(:account).each &:activate!
    end
  end
  
  def complete_pausing!
    transaction do
      _complete_pausing!
    end
  end
  
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
    self.username ||= project.username
    true
  end
end
