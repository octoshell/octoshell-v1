class Project < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  belongs_to :organization
  has_many :accounts, inverse_of: :project
  has_many :requests, inverse_of: :project
  has_many :tickets
  has_many :cluster_users
  
  validates :name, uniqueness: true
  validates :user, :name, :description, :organization, presence: true
  validates :organization, inclusion: { in: proc(&:allowed_organizations) }
  
  attr_accessible :name, :requests_attributes, :description, :organization_id
  attr_accessible :name, :requests_attributes, :description, :organization_id,
    :user_id, as: :admin
  
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
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      [accounts, requests, cluster_users].flatten.each &:close!
    end
  end
  
  def name_with_state
    "#{name} [#{human_state_name}]"
  end
  
  def active?
    requests.active.exists?
  end
  
  def username
    "project_#{id}"
  end
  
  def clusters
    Cluster.joins(:requests).where(requests: { state: 'active', project_id: id })
  end
  
  def allowed_organizations
    return Organization.all unless user
    
    memberships = user.memberships
    
    if new_record?
      memberships = memberships.active
    end
    
    memberships.uniq.map &:organization
  end
  
private
  
  def activate_accounts
    accounts.where(user_id: user_id).each(&:activate)
  end
end
