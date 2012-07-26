class PositionName < ActiveRecord::Base
  has_paper_trail
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
end
