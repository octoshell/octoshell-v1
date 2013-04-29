class Cluster::Log < ActiveRecord::Base
  attr_accessible :cluster_id, :message
end
