class Project < ActiveRecord::Base
  include Models::Limitable
  
  CLUSTER_USER_TYPES = %w(account project)
  has_paper_trail
  
  belongs_to :user
  belongs_to :organization
  has_many :accounts, inverse_of: :project
  has_many :tickets
  has_many :cluster_projects, autosave: true
  has_many :sureties, inverse_of: :project
  
  validates :name, uniqueness: true
  validates :user, :name, :description, :organization, presence: true
  validates :organization, inclusion: { in: proc(&:allowed_organizations) }
  validates :username, presence: true, on: :update
  validates :cluster_user_type, inclusion: { in: CLUSTER_USER_TYPES }
  
  attr_accessible :name, :description, :organization_id, :sureties_attributes
  attr_accessible :name, :description, :organization_id, :sureties_attributes,
    :user_id, :cluster_user_type, :username, as: :admin
  
  after_create :assign_username
  after_create :activate_accounts
  after_create :create_relations
  
  accepts_nested_attributes_for :sureties
  
  scope :finder, lambda { |q| where("name like :q", q: "%#{q}%") }
  
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
      cluster_projects.non_closed.each &:close!
      accounts.non_closed.each &:cancel!
      requests.non_closed.each &:force_close!
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
  
  def accesses
    Access.where(cluster_user_id: cluster_users.pluck(:id))
  end
  
  def username=(username)
    self[:username] = username
    cluster_projects.each { |cp| cp.username = username }
  end
  
  def tasks
    tasks = []
    cluster_projects.each do |cp|
      tasks += cp.tasks
      cp.cluster_users.each do |cu|
        tasks += cu.tasks
        cu.accesses.each do |a|
          tasks += a.tasks
        end
      end
    end
    tasks.sort_by(&:id)
  end
  
  def as_json(options)
    { id: id, text: name }
  end
  
private
  
  def activate_accounts
    accounts.where(user_id: user_id).first_or_create!
    accounts.where(user_id: user_id).each(&:activate)
    true
  end
  
  def assign_username
    update_attribute :username, "project_#{id}" unless username?
    true
  end
  
  def create_relations
    accounts.where(user_id: user_id).first_or_create!
    Cluster.active.each do |cluster|
      cluster_projects.where(cluster_id: cluster.id).first_or_create!
    end
  end
end
