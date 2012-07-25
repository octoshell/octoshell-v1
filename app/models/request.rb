class Request < ActiveRecord::Base
  include Models::Paranoid
  
  delegate :persisted?, to: :project, prefix: true, allow_nil: true
  
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  has_many :tasks, as: :resource
  
  validates :project, :cluster, :hours, :user, :size, presence: true, on: :create
  validates :project, inclusion: { in: proc(&:allowed_projects) },
    on: :create, if: :project_persisted?
  validates :size, :hours, numericality: { greater_than: 0 }
  
  attr_accessible :hours, :cluster_id, :project_id, :size
  attr_accessible :hours, :cluster_id, :project_id, :user_id, :size, as: :admin
  
  scope :active, where(state: 'active')
  scope :pending, where(state: 'pending')
  scope :declined, where(state: 'declined')
  scope :finished, where(state: 'finished')
  scope :last_pending, where(state: 'pending').order('id desc')
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :finished
    
    event :_activate do
      transition pending: :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_finish do
      transition active: :finished
    end
  end
  
  define_defaults_events :activate, :decline, :finish
  
  def waiting?
    tasks.pending.exists?
  end
  
  def activate
    return unless can_create_task?
    
    tasks.setup(:add_user)
  end
  
  def finish
    return unless can_create_task?
    return unless can__finish?
    
    if last_active_request?
      tasks.setup(:del_user)
      true
    else
      _finish
    end
  end
  
  def finish!
    self.class.transaction do
      _finish!
      
      project.accounts.each do |account|
        account.user.credentials.each do |credential|
          conditions = {
            credential_id: credential.id,
            cluster_id:    cluster.id,
            project_id:    project.id
          }
          Access.where(conditions).destroy_all
        end
      end
    end
  end
  
  def decline
    return unless can_create_task?
    _decline
  end
  
  def activate!
    self.class.transaction do
      _activate!
      
      project.accounts.active.each do |account|
        account.user.credentials.each do |credential|
          conditions = {
            credential_id: credential.id,
            cluster_id:    cluster.id,
            project_id:    project.id
          }
          Access.where(conditions).first_or_create!
        end
      end
    end
  end
  
  def finish_or_decline
    if pending?
      decline
    elsif active?
      finish
    else
      true
    end
  end
  
  def allowed_projects
    if user
      user.owned_projects
    else
      []
    end
  end
  
  def continue!(procedure)
    method = "continue_#{procedure}"
    send(method) if respond_to?(method)
  end
  
  def stop!(procedure)
  end
  
protected
  
  def continue_add_user
    activate!
  end
  
  def continue_del_user
    finish!
  end
  
private
  
  def can_create_task?
    valid?
    errors.add(:base, :pending_tasks_present) if waiting?
    errors.empty?
  end
  
  def last_active_request?
    conditions = {
      project_id: project_id,
      cluster_id: cluster_id
    }
    Request.active.where(conditions).count == 1
  end
end
