class CriticalTechnology < ActiveRecord::Base
  has_and_belongs_to_many :sureties
  
  attr_accessible :name
end
