class Request < ActiveRecord::Base
  include Models::Asynch
  has_paper_trail
  
  delegate :persisted?, to: :project, prefix: true, allow_nil: true
  
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  has_many :tasks, as: :resource
  
  validates :project, :cluster, :hours, :user, :size, presence: true
  validates :project, inclusion: { in: proc(&:allowed_projects) },
    on: :create, if: :project_persisted?
  validates :size, :hours, numericality: { greater_than: 0 }
  
  attr_accessible :hours, :cluster_id, :project_id, :size
  attr_accessible :hours, :cluster_id, :project_id, :user_id, :size, as: :admin
  
  scope :active, where(state: 'active')
  scope :pending, where(state: 'pending')
  scope :declined, where(state: 'declined')
  scope :closed, where(state: 'closed')
  scope :non_active, where("state != 'active'")
  scope :non_closed, where("state != 'closed'")
  scope :last_pending, where(state: 'pending').order('id desc')
  
  state_machine initial: :pending do
    state :pending
    state :activing
    state :active
    state :declined
    state :closing
    state :closed
    
    event :_activate do
      transition pending: :activing
    end
    
    event :_complete_activation do
      transition activing: :active
    end
    
    event :_failure_activation do
      transition activing: :pending
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_close do
      transition active: :closing
    end
    
    event :_complete_closure do
      transition closing: :closed
    end
    
    event :_force_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :complete_activation, :failure_activation,
    :complete_closure, :decline, :close
  
  def close!(message = nil)
    transaction do
      self.comment = message
      if can__close?
        if last_active_request?
          _close!
          tasks.setup(:block_user)
        else
          _close!
          _complete_closure!
        end
      else
        _force_close!
      end
    end
  end
  
  def activate!
    transaction do
      _activate!
      tasks.setup(:add_user)
    end
  end
  
  def complete_activation!
    transaction do
      _complete_activation!
      
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
  
  def allowed_projects
    user ? user.owned_projects : []
  end
  
protected
  
  def continue_block_user
    complete_closure!
  end
  
  def continue_unblock_user
    activate!
  end
  
private
  
  def last_active_request?
    conditions = {
      project_id: project_id,
      cluster_id: cluster_id
    }
    Request.active.where(conditions).count == 1
  end
end
