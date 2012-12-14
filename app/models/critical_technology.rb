class CriticalTechnology < ActiveRecord::Base
  has_and_belongs_to_many :projects
  
  attr_accessible :name, as: :admin
end
