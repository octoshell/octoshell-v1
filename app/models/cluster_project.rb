class ClusterProject < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  
  default_scope order("#{table_name}.id desc")
  
  belongs_to :project
  belongs_to :cluster
  has_many :cluster_users
  has_many :tasks, as: :resource
  has_many :requests
  
  validates :project, :cluster, presence: true
  
  after_create :create_relations
  before_create :assign_username
  
  state_machine initial: :initialized do
    state :initialized
    state :activing
    state :active
    state :pausing
    state :paused
    state :closing
    
    event :_activate do
      transition [:initialized, :paused] => :activing
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
      transition closing: :initialized
    end
  end
  
  define_defaults_events :activate, :complete_activation, :close,
    :complete_closure, :complete_pausing, :pause
  
  define_state_machine_scopes
  
  def activate!
    transaction do
      procedure = initialized? ? :add_project : :unblock_project
      _activate!
      tasks.setup(procedure)
    end
  end
  
  def pause!
    transaction do
      _pause!
      tasks.setup(:block_project)
    end
  end
  
  def close!
    transaction do
      _close!
      tasks.setup(:del_project)
    end
  end
  
  def complete_activation!
    transaction do
      _complete_activation!
      cluster_users.each &:activate!
    end
  end
  
  def complete_closure!
    transaction do
      _complete_closure!
      cluster_users.non_closed.each &:force_close!
    end
  end
  
  def complete_pausing!
    transaction do
      _complete_pausing!
    end
  end
  
  def check_process!
    if [:activing, :pausing, :closing].include?(state_name)
     raise RecordInProcess
    end
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
  
  def create_relations
    project.accounts.each do |account|
      cluster_users.where(account_id: account.id).first_or_create!
    end
  end
  
  def assign_username
    self.username ||= project.username
    true
  end
end
