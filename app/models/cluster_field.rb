class ClusterField < ActiveRecord::Base
  belongs_to :cluster
  
  validates :cluster, presence: true
  
  attr_accessible :cluster_id, :name, as: :admin
end
