class Project < ActiveRecord::Base
  has_paper_trail
  
  has_many :accounts
  has_many :requests
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
end
