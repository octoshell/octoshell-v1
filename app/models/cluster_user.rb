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
  
  attr_accessible :account_id, :cluster_project_id, :username, :state, as: :admin
  
  before_create :assign_username
  
  state_machine initial: :closed do
    state :activing
    state :active
    state :paused
    state :pausing
    state :closing
    state :closed
    
    event :activate do
      transition :closed => :activing
    end
    
    event :complete_activation do
      transition :activing => :active
    end
    
    event :close do
      transition :active => :closing
    end
    
    event :complete_closure do
      transition :closing => :closed
    end
    
    event :force_close do
      transition :active => :closed
    end
    
    event :block do
      transition :active => :pausing
    end
    
    event :complete_block do
      transition :pausing => :paused
    end
    
    event :unblock do
      transition :paused => :activing
    end
    
    event :complete_unblock do
      transition :activing => :active
    end
    
    around_transition :on => :unblock do |cu, _, block|
      cu.transaction do
        cu.check_process!
        block.call
        cu.tasks.setup(:unblock_user)
      end
    end
    
    around_transition :on => [:activate, :pause, :close] do |cu, _, block|
      cu.transaction do
        cu.check_process!
        block.call
        procedure = { activing: :add_user, pausing: :block_user, closing: :del_user }[cu.state_name]
        cu.tasks.setup(procedure)
      end
    end
    
    def continue_unblock_user(task)
      complete_unblock!
    end
    
    around_transition :on => :force_close do |cu, _, block|
      cu.transaction do
        block.call
        cu.accesses.non_closed.each &:force_close!
      end
    end
    
    around_transition :on => :complete_activation do |cu, _, block|
      cu.transaction do
        block.call
        cu.account.user.credentials.active.each do |credential|
          cu.accesses.where(credential_id: credential.id).first_or_create!
        end
        cu.accesses.each &:activate!
      end
    end
    
    around_transition :on => :complete_closure do |cu, _, block|
      cu.transaction do
        block.call
        cu.accesses.non_closed.each &:force_close!
      end
    end
  end
  define_state_machine_scopes
    
  def has_active_entities?
    !closed? || accesses.any?(&:has_active_entities?)
  end

  def link_name
    username
  end
  
  def check_process!
    if [:activing, :blocking, :closing].include?(state_name)
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
  
  def continue_block_user(task)
    complete_block!
  end
  
  def continue_unblock_user(task)
    complete_unblock!
  end

private
  
  def assign_username
    self.username ||= account.reload.login
    true
  end
end
