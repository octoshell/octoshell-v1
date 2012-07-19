class Project < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  has_many :accounts, inverse_of: :project
  has_many :requests, inverse_of: :project
  
  validates :name, uniqueness: true
  validates :user, :name, :description, presence: true
  
  attr_accessible :name, :requests_attributes, :description
  attr_accessible :name, :requests_attributes, :description, :user_id, as: :admin
  
  accepts_nested_attributes_for :requests
  
  def active?
    requests.
    active.exists?
  end
  
  def username
    "project_#{id}"
  end
end
