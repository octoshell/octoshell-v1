class Project < ActiveRecord::Base
  has_paper_trail
  
  has_many :accounts
  has_many :requests, inverse_of: :project
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name, :requests_attributes
  
  accepts_nested_attributes_for :requests
end
