class Cluster < ActiveRecord::Base
  has_many :requests
  
  validates :name, presence: true
  
  attr_accessible :name
  
  before_destroy :cancel_requests
  
private
  
  def cancel_requests
    requests.each do |request|
      request.comment = I18n.t('requests.cluster_destroyed')
      request.finish_or_decline!
    end
  end
end
