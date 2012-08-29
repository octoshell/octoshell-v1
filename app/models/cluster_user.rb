# Пользователь на кластере
class ClusterUser < ActiveRecord::Base
  has_paper_trail
  include Models::Asynch
  
  default_scope order("#{table_name}.id desc")
  delegate :username, to: :project
  
  attr_accessor :skip_activation
  
  belongs_to :cluster
  belongs_to :project
  belongs_to :request # last request
  has_many :tasks, as: :resource
  has_many :accesses
  
  validates :cluster, :project, :request, presence: true
  
  after_create :activate!, unless: :skip_activation
  
  state_machine initial: :pending do
    state :pending
    state :activing
    state :active
    state :pausing
    state :paused
    state :resuming
    state :closing
    state :closed
    
    event :_activate do
      transition pending: :activing
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
    
    event :_resume do
      transition paused: :resuming
    end
    
    event :_complete_resuming do
      transition resuming: :active
    end
    
    event :_close do
      transition [:pending, :activing, :active, :pausing, :paused, :resuming] => :closing
    end
    
    event :_complete_closure do
      transition closing: :closed
    end
    
    event :_force_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :complete_activation, :pause,
    :complete_pausing, :resume, :complete_resuming, :close, :complete_closure,
    :force_close
  
  define_state_machine_scopes
  
  class << self
    def activate_for(project_id, cluster_id, request_id)
      conditions = { project_id: project_id, cluster_id: cluster_id }
      if cluster_user = non_closed.where(conditions).first
        transaction do
          cluster_user.update_attribute(:request_id, request_id)
          cluster_user.activate!
        end
      else
        create! do |cluster_user|
          cluster_user.project_id = project_id
          cluster_user.cluster_id = cluster_id
          cluster_user.request_id = request_id
        end
      end
    end
    
    def pause_for(project_id, cluster_id)
      conditions = { project_id: project_id, cluster_id: cluster_id }
      active.where(conditions).each &:pause!
    end
    
    def close_for(project_id, cluster_id)
      conditions = { project_id: project_id, cluster_id: cluster_id }
      non_closed.non_closing.where(conditions).each &:close!
    end
  end
  
  def users
    users = []
    users << project.user
    users << project.accounts.active.map(&:user)
    users.flatten.uniq
  end
  
  def processing?
    [:activing, :pausing, :resuming, :closing].include? state_name
  end
  
  def activate
    if processing?
      errors.add(:base, :processing) 
      false
    else
      activate!
    end
  end
  
  def activate!
    transaction do
      errors.add(:base, :processing) if processing?
      
      if paused?
        resume!
      else
        active? or _activate!
        tasks.setup(:add_user)
      end
    end
  end
  
  def pause!
    transaction do
      _pause!
      tasks.setup(:block_user)
    end
  end
  
  def resume!
    transaction do
      _resume!
      tasks.setup(:unblock_user)
    end
  end
  
  def close!
    transaction do
      if pending?
        _close!
        _complete_closure!
      else
        _close!
        tasks.setup(:del_user)
      end
    end
  end
  
  def complete_activation!
    transaction do
      _complete_activation!
      
      project.accounts.active.each do |account|
        account.user.credentials.active.each do |credential|
          accesses.where(credential_id: credential.id).first_or_create!
        end
      end
    end
  end
  
protected
  
  def continue_add_user(task)
    complete_activation!
  end
  
  def continue_block_user(task)
    complete_pausing!
  end
  
  def continue_unblock_user(task)
    complete_resuming!
  end
  
  def continue_del_user(task)
    complete_closure!
  end
end
