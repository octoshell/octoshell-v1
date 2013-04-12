# coding: utf-8
class Project < ActiveRecord::Base
  CLUSTER_USER_TYPES = %w(account project)
  has_paper_trail
  
  include Models::Limitable
  
  belongs_to :user
  belongs_to :organization
  belongs_to :project_prefix
  has_one :card, class_name: :'Project::Card', inverse_of: :project
  has_and_belongs_to_many :organizations
  has_many :accounts, inverse_of: :project, autosave: true
  has_many :account_codes
  has_many :tickets
  has_many :requests
  has_many :sureties, inverse_of: :project
  has_and_belongs_to_many :critical_technologies
  has_and_belongs_to_many :direction_of_sciences
  has_and_belongs_to_many :research_areas
  
  with_options unless: :disabled? do |enabled|
    enabled.validates :user, :organization, :title, presence: true
    enabled.validates :cluster_user_type, inclusion: { in: CLUSTER_USER_TYPES }
    enabled.validates :direction_of_science_ids, :critical_technology_ids,
      :research_area_ids, length: { minimum: 1, message: 'выберите не менее %{count}' }
  end
  
  attr_accessible :organization_id, :sureties_attributes,
    :organization_ids, :direction_of_science_ids, :critical_technology_ids,
    :project_prefix_id, :research_area_ids, :title, :card_attributes
  
  attr_accessible :project_prefix_id, :username, as: :admin
  
  after_create :assign_username
  after_create :create_account_for_owner
  
  accepts_nested_attributes_for :sureties, :card
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q.to_s.mb_chars.downcase}%") }
  scope :enabled, where(disabled: false)
  
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
  
  def disable!
    self.disabled = true
    save!
  end
  
  def unregistered_members
    sureties.without_state(:closed).map do |surety|
      surety.surety_members.where(user_id: nil).find_all do |sm|
        sm.account_code
      end
    end.flatten
  end
  
  def name_with_state
    "#{title} [#{human_state_name}]"
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
    title
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
  
  def ok?
    requests.with_state(:active).any? &&
      requests.with_state(:pending, :blocked).empty? && 
      sureties.with_state(:filling, :generated, :confirmed).empty? && 
      accounts.with_access_state(:allowed).with_cluster_state(:closed, :blocked).empty?
  end
  
private
  
  def assign_username
    name = username? ? username : "project_#{id}"
    update_attribute :username, name
    true
  end
  
  def create_account_for_owner
    conditions = { project_id: id, user_id: user_id }
    account = Account.where(conditions).first_or_create!
    account.allow! unless account.allowed?
    true
  end
end
