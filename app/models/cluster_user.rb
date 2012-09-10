# Пользователь на кластере
class ClusterUser < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  
  default_scope order("#{table_name}.id desc")
  
  delegate :project, :cluster, to: :cluster_project, allow_nil: true
  delegate :username, to: :account, allow_nil: true
  
  belongs_to :account
  belongs_to :cluster_project
  has_many :accesses
  has_many :tasks, as: :resource
  
  validates :account, :cluster_project, presence: true
  
  after_create :create_relations
  
  state_machine initial: :initialized do
    state :initialized
    state :activing
    state :active
    state :closing
    
    event :_activate do
      transition initialized: :activing
    end
    
    event :_complete_activation do
      transition activing: :active
    end
    
    event :_close do
      transition active: :closing
    end
    
    event :_complete_closure do
      transition closing: :initialized
    end
    
    event :_force_close do
      transition [:initialized, :active] => :closed
    end
  end
  
  define_defaults_events :activate, :complete_activation, :close,
    :complete_closure
  
  define_state_machine_scopes
  
  def force_close!
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
      accesses.non_initialized.each &:force_close!
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
    account.user.credentials.each do |credential|
      conditions = { credential_id: credential.id }
      accesses.where(conditions).first_or_create!
    end
  end
end
