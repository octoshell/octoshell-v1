class Field < ActiveRecord::Base
  has_paper_trail
  
  attr_accessible :code, :name, :position
  
  validates :name, :code, :position, presence: true
end
