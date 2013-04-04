# coding: utf-8
class Project < ActiveRecord::Base
  CLUSTER_USER_TYPES = %w(account project)
  has_paper_trail
  
  include Models::Limitable
  
  belongs_to :user
  belongs_to :organization
  belongs_to :project_prefix
  has_one :card, class_name: :'Project::Card'
  has_and_belongs_to_many :organizations
  has_many :accounts, inverse_of: :project, autosave: true
  has_many :account_codes
  has_many :tickets
  has_many :requests
  has_many :sureties, inverse_of: :project
  has_and_belongs_to_many :critical_technologies
  has_and_belongs_to_many :direction_of_sciences
  has_and_belongs_to_many :research_areas
  
  validates :user, :organization, presence: true
  validates :cluster_user_type, inclusion: { in: CLUSTER_USER_TYPES }
  validates :direction_of_science_ids, :critical_technology_ids,
    :research_area_ids, length: { minimum: 1, message: 'выберите не менее %{count}' }
  
  attr_accessible :organization_id, :sureties_attributes,
    :organization_ids, :direction_of_science_ids, :critical_technology_ids,
    :project_prefix_id, :research_area_ids
  
  attr_accessible :project_prefix_id, :username, as: :admin
  
  after_create :assign_username
  
  accepts_nested_attributes_for :sureties, :card
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q.to_s.mb_chars.downcase}%") }
  
  state_machine :state, initial: :active do
    state :active
    state :closing
    state :closed
    
    event :close do
      transition :active => :closing
    end
    
    event :resurrect do
      transition :closing => :active
    end
    
    event :erase do
      transition :closing => :closed
    end
    
    inside_transition :on => :close do |p|
      p.requests.with_state(:active).each &:block!
    end
    
    inside_transition :on => :erase do |p|
      p.requests.with_state(:blocked).each &:close!
      p.accounts.with_cluster_state(:blocked).each &:close!
    end
  end
  
  def name_with_state
    "#{name} [#{human_state_name}]"
  end
  
  def allowed_organizations
    user.active_organizations
  end
  
  def username=(username)
    self[:username] = username
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
  
  def has_active_request?
    requests.active.any?
  end
  
  def has_requests?
    requests.any?
  end
  
  def notify_about_blocking
    accounts.active.each do |account|
      Mailer.project_blocked(account).deliver
    end
  end
  
private
  
  def assign_username
    name = username? ? username : "project_#{id}"
    update_attribute :username, name
    true
  end
end
