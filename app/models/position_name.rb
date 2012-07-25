class PositionName < ActiveRecord::Base
  include Models::Paranoid
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
end
