class Request < ActiveRecord::Base
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  
  validates :project, :cluster, :hours, presence: true
  
  attr_accessible :hours, :cluster_id
end
