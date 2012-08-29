class ClusterField < ActiveRecord::Base
  belongs_to :cluster
  
  validates :cluster, presence: true
end
