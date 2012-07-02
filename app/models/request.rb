class Request < ActiveRecord::Base
  belongs_to :project
  belongs_to :cluster
  
  validates :project, :cluster, :hours, presence: true
  
  attr_accessible :hours
end
