# coding: utf-8
class Project < ActiveRecord::Base
  include Models::Limitable
  
  CLUSTER_USER_TYPES = %w(account project)
  has_paper_trail
  
  belongs_to :user
  belongs_to :organization
  belongs_to :project_prefix
  has_and_belongs_to_many :organizations
  has_many :accounts, inverse_of: :project
  has_many :account_codes
  has_many :tickets
  has_many :cluster_projects, autosave: true
  has_many :sureties, inverse_of: :project
  has_and_belongs_to_many :critical_technologies
  has_and_belongs_to_many :direction_of_sciences
  
  validates :name, uniqueness: true
  validates :user, :name, :description, :organization, presence: true
  validates :organization, inclusion: { in: proc(&:allowed_organizations) }
  validates :username, presence: true, on: :update
  validates :cluster_user_type, inclusion: { in: CLUSTER_USER_TYPES }
  validates :direction_of_science_ids, :critical_technology_ids,
    length: { minimum: 1, message: 'выберите не менее %{count}' }
  
  attr_accessible :name, :description, :organization_id, :sureties_attributes,
    :organization_ids, :direction_of_science_ids, :critical_technology_ids,
    :project_prefix_id
  attr_accessible :user_id, :organization_id, :organization_ids,
    :project_prefix_id, :name, :username, :description,
    :direction_of_science_ids, :critical_technology_ids, :cluster_user_type,
    as: :admin
  
  after_create :assign_username
  after_create :create_relations
  
  accepts_nested_attributes_for :sureties
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q.to_s.mb_chars.downcase}%") }
  
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
    memberships = user.memberships.active.map(&:organization).uniq
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
  
  def build_additional_surety
    last_surety = sureties.last
    sureties.build do |surety|
      %w(cpu_hours gpu_hours size boss_full_name boss_position).each do |attr|
        surety.send "#{attr}=", last_surety.send(attr)
      end if last_surety
    end
  end

  def login
    "#{project_prefix}#{username}"
  end

  def link_name
    name
  end
  
private
  
  def assign_username
    name = username? ? username : "project_#{id}"
    update_attribute :username, name
    true
  end
  
  def create_relations
    a = accounts.where(user_id: user_id).first_or_create!
    a.activate!
    Cluster.active.each do |cluster|
      cluster_projects.where(cluster_id: cluster.id).first_or_create!
    end
  end
end
