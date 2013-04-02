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
  
  accepts_nested_attributes_for :sureties
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q.to_s.mb_chars.downcase}%") }
  
  state_machine :state, initial: :announced do
    state :announced
    state :active
    state :blocked
    state :closing
    state :closed
    
    event :activate do
      transition :announced => :active
    end
    
    event :unblock do
      transition :blocked => :active
    end
    
    event :close do
      transition [:announced, :active, :blocked] => :closing
    end
    
    event :erase do
      transition :closing => :closed
    end
    
    event :block do
      transition :active => :blocked
    end
    
    inside_transition :on => :block do |p|
      p.accounts.with_cluster_state(:active).each &:block!
      p.touch :maintain_requested_at
    end
    
    inside_transition :on => :unblock do |p|
      p.accounts.with_cluster_state(:blocked).each &:unblock!
      p.touch :maintain_requested_at
    end
    
    inside_transition :on => :close do |p|
      p.accounts.without_cluster_state(:closed).each &:close!
      p.touch :maintain_requested_at
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
