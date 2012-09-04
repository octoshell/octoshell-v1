class ClusterProject < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  
  default_scope order("#{table_name}.id desc")
  
  belongs_to :request
  belongs_to :project
  belongs_to :cluster
  has_many :cluster_users
  
  after_commit :create_relations
  
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
      transition active: :closing
    end
    
    event :_complete_closure do
      transition closing: :initialized
    end
  end
  
  define_defaults_events :activate, :complete_activation, :close,
    :complete_closure, :complete_pausing
  
  define_state_machine_scopes
  
  def activate!
    transaction do
      procedure =
        initialized? ? :add_cluster_project : :unblock_cluster_project
      _activate!
      tasks.setup(procedure)
    end
  end
  
  def pause!
    transaction do
      _pause!
      tasks.setup(:block_cluster_project)
    end
  end
  
  def close!
    transaction do
      _pause!
      tasks.setup(:unblock_cluster_project)
    end
  end
  
  def check_process!
    if [:activing, :pausing, :closing].include?(state_name)
      raise RecordInProcess
    end
  end
  
protected
  
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
      cluster_users.each &:close!
    end
  end
  
private
  
  def create_relations
    project.accounts.each do |account|
      cluster_users.where(account_id: account.id).first_or_create!
    end
  end
end
