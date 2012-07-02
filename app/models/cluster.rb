class Cluster < ActiveRecord::Base
  has_many :requests
  
  validates :name, presence: true
  
  attr_accessible :name
end
