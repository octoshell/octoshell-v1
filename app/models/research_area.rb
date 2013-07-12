# Область исследований
class ResearchArea < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  validates :group, :name, presence: true
  
  attr_accessible :group, :name, as: :admin
end
