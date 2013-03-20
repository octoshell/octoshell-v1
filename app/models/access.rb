# coding: utf-8
class Access < ActiveRecord::Base
  delegate :cluster, to: :cluster_user
  delegate :state_name, to: :credential, prefix: true, allow_nil: true
  
  include Models::Asynch
  include Models::MarkableForTask
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  attr_accessor :skip_activation
  
  belongs_to :cluster_user
  belongs_to :credential
  has_many :tasks, as: :resource, dependent: :destroy
  
  validates :credential, :cluster_user, presence: true
  validates :credential_state_name, inclusion: { in: [:active] }, if: proc { |a| a.active? || a.activing? }
  
  attr_accessible :cluster_user_id, :credential_id, :state, as: :admin
  
  state_machine initial: :closed do
    state :closed
    state :activing
    state :active
    state :closing
    
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
    
    around_transition :on => :activate do |access, _, block|
      access.transaction do
        access.check_process!
        block.call
        access.mark_for_task!
      end
    end
    
    around_transition :on => [:close, :force_close] do |access, _, block|
      access.transaction do
        access.check_process!
        block.call
      end
    end
  end  
  define_state_machine_scopes
  
  def available?
    cluster_user.active? && cluster_user.cluster_project.active?
  end
  
  def check_process!
    if [:activing, :closing].include?(state_name)
      raise ActiveRecord::RecordInProcess
    end
  end
  
  def human_active_state
    if cluster_user.cluster_project.project.requests.where(state: 'active').any?
      human_state_name
    else
      "Нет активной заявки"
    end
  end
  
  def has_active_entities?
    !closed?
  end

  def link_name
    'access'
  end
  
protected
  
  def continue_add_openkey(task)
    complete_activation!
  end
  
  def continue_del_openkey(task)
    complete_closure!
  end
end
