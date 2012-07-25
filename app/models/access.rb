# Модель доступа к кластеру
# `activate` - запускает процесс добавления ключа на кластер
# `close` - закрывает доступ удаляя ключ с кластера
# `force_close` - закрывает доступ не удаляя ключ с кластера 
# (при удалении вручную или всего пользователя на кластере)
class Access < ActiveRecord::Base
  include Models::Asynch
  
  attr_accessor :skip_activation
  
  belongs_to :project
  belongs_to :credential
  belongs_to :cluster
  has_many :tasks, as: :resource
  
  validates :project, :credential, :cluster, presence: true
  # validates :project_id, uniqueness: { scope: [:credential_id, :cluster_id] }
  
  scope :non_closed, where("state != 'closed'")
  
  after_create :activate, unless: :skip_activation
  
  state_machine initial: :pending do
    state :pending
    state :activing
    state :active
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
    
    event :_close do
      transition any => :closing
    end
    
    event :_complete_closure do
      transition closing: :closed
    end
    
    event :_failure_closure do
      transition closing: :active
    end
    
    event :_force_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :complete_activation, :failure_activation,
    :close, :complete_closure, :failure_closure, :force_close
  
  # активирует (создает задачу для доступа к кластеру)
  def activate!
    self.class.transaction do
      _activate!
      tasks.setup(:add_openkey)
    end
    true
  end
  
  # закрывает доступ (создает задачу для закрытия доступа к кластеру)
  def close!
    self.class.transaction do
      _close!
      tasks.setup(:del_openkey)
    end
    true
  end
  
protected
  
  def continue_add_openkey
    complete_activation!
  end
  
  def stop_add_openkey
    failure_activation!
  end
  
  def continue_del_openkey
    complete_closure!
  end
  
  def stop_del_openkey
    failure_closure!
  end
end
