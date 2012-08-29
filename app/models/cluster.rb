class Cluster < ActiveRecord::Base
  has_paper_trail
  
  include Models::Asynch
  
  default_scope order("#{table_name}.name asc")
  
  has_many :requests
  has_many :cluster_users
  has_many :tickets
  has_many :projects, through: :requests
  has_many :tasks, as: :resource
  has_many :cluster_fields
  
  validates :name, :host, :add_user, :del_user, :add_openkey,
   :del_openkey, :block_user, :unblock_user, :get_statistic, presence: true
  
  attr_accessible :name, :host, :description, :add_user, :del_user,
    :add_openkey, :del_openkey, :block_user, :unblock_user,
    :get_statistic, as: :admin
  
  state_machine initial: :active do
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      requests.non_closed.each do |request|
        request.comment = I18n.t('requests.cluster_closed')
        request.close!
      end
    end
  end
  
  def cluster
    self
  end
  
protected
  
  def continue_get_statistic(task)
    update_attribute :statistic, task.stdout
    update_attribute :statistic_updated_at, task.updated_at
  end
end
