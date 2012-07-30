class Project < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  has_many :accounts, inverse_of: :project
  has_many :requests, inverse_of: :project
  has_many :cluster_users
  
  validates :name, uniqueness: true
  validates :user, :name, :description, presence: true
  
  attr_accessible :name, :requests_attributes, :description
  attr_accessible :name, :requests_attributes, :description, :user_id, as: :admin
  
  accepts_nested_attributes_for :requests
  
  after_create :activate_accounts
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  def close!
    transaction do
      _close!
      accounts.each &:close!
      requests.each &:close!
    end
  end
  
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
