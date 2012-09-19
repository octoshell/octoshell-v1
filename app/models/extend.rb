class Extend < ActiveRecord::Base
  attr_accessible :script, :url, as: :admin
  
  validates :script, :url, presence: true
end
