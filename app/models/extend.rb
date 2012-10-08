class Extend < ActiveRecord::Base
  attr_accessible :script, :url, :header, :footer, :weight, as: :admin
  
  validates :script, :url, presence: true
end
