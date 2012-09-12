# Пользователь на кластере
class ClusterUser < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  
  delegate :state_name, to: :account, allow_nil: true, prefix: true
  
  default_scope order("#{table_name}.id desc")
  
  delegate :project, :cluster, to: :cluster_project, allow_nil: true
  
  belongs_to :account
  belongs_to :cluster_project
  has_many :accesses, dependent: :destroy
  has_many :tasks, as: :resource, dependent: :destroy
  
  validates :account, :cluster_project, presence: true
  validates :account_state_name, inclusion: { in: [:active] }, if: proc { |c| c.active? || c.activing? }
  
  after_create :create_relations
  before_create :assign_username
  
  state_machine initial: :closed do
    state :closed
    state :activing
    state :active
    state :closing
    
    event :_activate do
      transition closed: :activing
    end
    
    event :_complete_activation do
      transition activing: :active
    end
    
    event :_close do
      transition active: :closing
    end
    
    event :_complete_closure do
      transition closing: :closed
    end
    
    event :_force_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :activate, :complete_activation, :close,
    :complete_closure
  
  define_state_machine_scopes
  
  def activate!
    check_process!
    
    transaction do
      _activate!
      tasks.setup(:add_user)
    end
  end
  
  def close!
    check_process!
    
    transaction do
      _close!
      tasks.setup(:del_user)
    end
  end
  
  def force_close!
    check_process!
    
    transaction do
      _force_close!
      accesses.non_closed.each &:force_close!
    end
  end
  
  def complete_activation!
    transaction do
      _complete_activation!
      accesses.each &:activate!
    end
  end
  
  def complete_closure!
    transaction do
      _complete_closure!
      accesses.non_closed.each &:force_close!
    end
  end
  
  def check_process!
    if [:activing, :closing].include?(state_name)
      raise ActiveRecord::RecordInProcess
    end
  end
  
protected
  
  def continue_add_user(task)
    complete_activation!
  end
  
  def continue_del_user(task)
    complete_closure!
  end

private
  
  def create_relations
    account.user.credentials.active.each do |credential|
      conditions = { credential_id: credential.id }
      accesses.where(conditions).first_or_create!
    end
  end
  
  def assign_username
    self.username ||= account.reload.username
    true
  end
end
