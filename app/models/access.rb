class Access < ActiveRecord::Base
  delegate :cluster, to: :cluster_user
  delegate :state_name, to: :credential, prefix: true, allow_nil: true
  
  include Models::Asynch
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  attr_accessor :skip_activation
  
  belongs_to :cluster_user
  belongs_to :credential
  has_many :tasks, as: :resource
  
  validates :credential, :cluster_user, presence: true
  validates :credential_state_name, inclusion: { in: [:active] }, on: :create
  
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
      transition any => :initialized
    end
  end
  
  define_defaults_events :activate, :complete_activation, :close,
    :complete_closure, :force_close
  
  define_state_machine_scopes
  
  # активирует (создает задачу для доступа к кластеру)
  def activate!
    transaction do
      _activate!
      tasks.setup(:add_openkey)
    end
    true
  end
  
  # закрывает доступ (создает задачу для закрытия доступа к кластеру)
  def close!
    transaction do
      _close!
      tasks.setup(:del_openkey)
    end
    true
  end
  
protected
  
  def continue_add_openkey(task)
    complete_activation!
  end
  
  def continue_del_openkey(task)
    complete_closure!
  end
end
