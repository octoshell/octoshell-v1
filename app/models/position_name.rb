class PositionName < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
end
