class Extend < ActiveRecord::Base
  attr_accessible :script, :url, :header, :footer, as: :admin
  
  validates :script, :url, presence: true
end
