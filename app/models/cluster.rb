class Cluster < ActiveRecord::Base
  has_paper_trail
  
  has_many :requests
  
  validates :name, :host, presence: true
  
  attr_accessible :name, :host, :description
  
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
