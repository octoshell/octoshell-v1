class Project < ActiveRecord::Base
  include Models::Paranoid
  
  has_paper_trail
  
  belongs_to :user
  has_many :accounts, inverse_of: :project
  has_many :requests, inverse_of: :project
  
  validates :name, uniqueness: true
  validates :user, :name, :description, presence: true
  
  attr_accessible :name, :requests_attributes, :description
  attr_accessible :name, :requests_attributes, :description, :user_id, as: :admin
  
  accepts_nested_attributes_for :requests
  
  after_create :activate_accounts
  
  def active?
    requests.
    active.exists?
  end
  
  def username
    "project_#{id}"
  end
  
  def clusters
    Cluster.joins(:requests).where(requests: { state: 'active', project_id: id })
  end
  
private
  
  def activate_accounts
    accounts.where(user_id: user_id).each(&:activate)
  end
end
