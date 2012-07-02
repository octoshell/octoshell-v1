class Field < ActiveRecord::Base
  has_paper_trail
  
  attr_accessible :code, :name, :position, as: :admin
  
  validates :name, :code, :position, presence: true
end
