class Project < ActiveRecord::Base
  CLUSTER_USER_TYPES = %w(account project)
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  belongs_to :user
  belongs_to :organization
  has_many :accounts, inverse_of: :project
  has_many :tickets
  has_many :cluster_projects, autosave: true
  
  validates :name, uniqueness: true
  validates :user, :name, :description, :organization, presence: true
  validates :organization, inclusion: { in: proc(&:allowed_organizations) }
  validates :username, presence: true, on: :update
  validates :cluster_user_type, inclusion: { in: CLUSTER_USER_TYPES }
  
  attr_accessible :name, :description, :organization_id
  attr_accessible :name, :description, :organization_id, :user_id,
    :cluster_user_type, :username, as: :admin
  
  after_create :assign_username
  after_create :activate_accounts
  after_create :create_relations
  
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
      accounts.non_closed.each &:close!
      cluster_projects.non_closed.each &:close!
      requests.non_closed.each &:close!
    end
  end
  
  def name_with_state
    "#{name} [#{human_state_name}]"
  end
  
  def requests
    Request.where(cluster_project_id: cluster_project_ids)
  end
  
  def allowed_organizations
    return Organization.active unless user
    
    memberships = user.memberships
    
    if new_record?
      memberships = memberships.active
    end
    
    memberships.uniq.map &:organization
  end
  
  def cluster_users
    ClusterUser.where(cluster_project_id: cluster_project_ids)
  end
  
  def username=(username)
    self[:username] = username
    cluster_projects.each { |cp| cp.username = username }
  end
  
private
  
  def activate_accounts
    accounts.where(user_id: user_id).each(&:activate)
    true
  end
  
  def assign_username
    update_attribute :username, "project_#{id}" unless username?
    true
  end
  
  def create_relations
    User.all.each do |user|
      accounts.where(user_id: user.id).first_or_create!
    end
    Cluster.all.each do |cluster|
      cluster_projects.where(cluster_id: cluster.id).first_or_create!
    end
  end
end
