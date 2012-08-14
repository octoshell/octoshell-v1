class Cluster < ActiveRecord::Base
  has_paper_trail
  
  has_many :requests
  has_many :cluster_users
  has_many :tickets
  has_many :projects, through: :requests, uniq: true
  
  validates :name, :host, :add_user, :del_user, :add_openkey,
   :del_openkey, :block_user, :unblock_user, presence: true
  
  attr_accessible :name, :host, :description, :add_user, :del_user,
    :add_openkey, :del_openkey, :block_user, :unblock_user, as: :admin
  
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
end
