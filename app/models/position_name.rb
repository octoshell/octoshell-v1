class PositionName < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
end
