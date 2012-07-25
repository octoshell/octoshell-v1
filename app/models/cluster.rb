class Cluster < ActiveRecord::Base
  has_many :requests
  
  validates :name, :host, presence: true
  
  attr_accessible :name, :host, :description
  
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
