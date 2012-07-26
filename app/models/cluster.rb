class Cluster < ActiveRecord::Base
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
  
  def close!
    transaction do
      _close!
      requests.non_closed.each do |r|
        r.close!(I18n.t('requests.cluster_closed'))
      end
    end
  end
  
private
  
  def cancel_requests
    stop = proc do |request|
      request.comment = I18n.t('requests.cluster_destroyed')
      request.finish_or_decline
    end
    
    requests.all?(&stop) || begin
      errors.add(:base, :failed_to_stop_all_requests)
      false
    end
  end
end
