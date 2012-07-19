class PositionName < ActiveRecord::Base
  acts_as_paranoid
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
end
