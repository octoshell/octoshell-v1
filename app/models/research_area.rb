class ResearchArea < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  attr_accessible :group, :name, as: :admin
end
