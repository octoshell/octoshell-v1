class Request < ActiveRecord::Base
  delegate :persisted?, to: :project, prefix: true
  
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  has_many :tasks, as: :resource
  
  validates :project, :cluster, :hours, :user, :size, presence: true
  validates :project, inclusion: { in: proc(&:allowed_projects) },
    on: :create, if: :project_persisted?
  validates :size, numericality: { greater_than: 0 }
  
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
    return if waiting?
    
    tasks.setup(:add_user)
  end
  
  def activate!
    self.class.transaction do
      _activate!
      
      request.project.users.active.each do |user|
        user.credentials.each do |credential|
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
  
  def finish_or_decline!
    if pending?
      decline!
    elsif active?
      finish!
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
  
private
  
  def continue_add_user
    activate!
  end
end
