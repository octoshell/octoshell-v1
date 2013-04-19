# coding: utf-8
# Модель доступа человека к проекту
class Account < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :state_name, to: :user, prefix: true, allow_nil: true
  delegate :state_name, to: :project, prefix: true, allow_nil: true
  
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  
  validates :user, :project, presence: true
  validates :username, presence: true, on: :update
  
  attr_accessible :user_id
  
  scope :by_params, proc { |p| where(project_id: p[:project_id], user_id: p[:user_id]) }
  
  after_create :assign_username
  
  # доступ к кластеру. выполнил ли пользователь необходимые условия для доступа
  state_machine :cluster_state, initial: :closed do
    state :active do
      validates :project_state_name, inclusion: { in: [:active] }
      validates :user_state_name, inclusion: { in: [:sured] }
    end
    state :blocked do
      validates :project_state_name, inclusion: { in: [:active, :closing] }
    end
    state :closed
    
    event :activate do
      transition :closed => :active
    end
    
    event :block do
      transition :active => :blocked
    end
    
    event :unblock do
      transition :blocked => :active
    end
    
    event :close do
      transition [:active, :blocked] => :closed
    end
  end
  
  # доступ к проекту. разрешил ли руководитель доступ
  state_machine :access_state, initial: :denied do
    state :denied
    state :allowed
    
    event :allow do
      transition :denied => :allowed
    end
    
    event :deny do
      transition :allowed => :denied
    end
    
    inside_transition :on => :allow, &:activate
    inside_transition :on => :deny, &:block
  end
  
  def username=(username)
    self[:username] = username
  end
  
  def to_s
    username
  end

  def login
    "#{project.project_prefix}#{username}"
  end

  def link_name
    to_s
  end
  
private
  
  def assign_username
    update_attribute :username, "#{user.username}_#{id}"
  end
end
