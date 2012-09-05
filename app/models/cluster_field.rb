class ClusterField < ActiveRecord::Base
  belongs_to :cluster
  
  validates :cluster, presence: true
  
  after_create :create_request_properties
  
  attr_accessible :cluster_id, :name, as: :admin

private

  def create_request_properties
    cluster.cluster_projects.map(&:requests).flatten.each do |request|
      RequestProperty.create! do |request_property|
        request_property.name = name
        request_property.request = request
      end
    end
  end
end
