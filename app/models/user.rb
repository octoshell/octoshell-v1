class User < ActiveRecord::Base
  has_paper_trail
  
  has_attached_file :avatar
  
  default_scope order("#{table_name}.id desc")
  
  authenticates_with_sorcery!
  
  attr_reader :new_organization
  attr_reader :organization_id
  
  has_many :accounts, inverse_of: :user
  has_many :credentials
  has_many :requests
  has_many :owned_projects, class_name: :Project
  has_many :projects, through: :accounts
  has_many :memberships
  has_many :sureties
  has_many :organizations, through: :sureties
  has_many :accesses, through: :credentials
  has_many :tickets
  
  validates :first_name, :last_name, :email, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, on: :update, if: :password?
  validates :email, uniqueness: true
  validates_attachment :avatar, size: { in: 0..150.kilobytes }
  
  before_create :assign_token
  after_create :create_relations
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :avatar
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :admin, :avatar, as: :admin
  
  scope :admins, where(admin: true)
  
  state_machine initial: :active do
    state :active
    state :sured
    state :closed
    
    event :_sure do
      transition active: :sured
    end
    
    event :_unsure do
      transition sured: :active
    end
    
    event :_close do
      transition [:active, :sured] => :closed
    end
  end
  
  define_defaults_events :close, :sure, :unsure
  
  define_state_machine_scopes
  
  class << self
    def initialize_with_auth_errors(email)
      auth = User.new(email: email)
      if user = User.find_by_email(email)
        if user.closed?
          auth.errors.add :base, :closed
        elsif user.activation_pending?
          auth.errors.add :base, :user_is_not_activated
        else
          auth.errors.add :base, :wrong_password
        end
      else
        auth.errors.add :base, :user_is_not_registered
      end
      auth
    end
  end
  
  def new_organization=(attributes)
    if attributes.values.any?(&:present?)
      @new_organization = organizations.build(attributes)
    end
  end
  
  def organization_id=(id)
    return if id.blank?
    raise 'Only for new records' if persisted?
    self.organizations = [Organization.find(id)]
  end
  
  def password?
    password.present?
  end
  
  def full_name
    [first_name, middle_name, last_name].find_all(&:present?).join(' ')
  end
  
  def start_steps
    steps = []
    steps << step_name(:project) if !projects.non_closed.any? && sured?
    if !sureties.active.exists?
      if sureties.pending.exists?
        steps << step_name(:send_and_wait_approve)
      else
        steps << step_name(:surety)
      end
    end
    steps << step_name(:membership) unless memberships.active.any?
    steps << step_name(:credential) unless credentials.active.any?
    steps
  end
  
  def project_steps
    steps = []
    if !sureties.active.exists?
      if sureties.pending.exists?
        steps << step_name(:send_and_wait_approve)
      else
        steps << step_name(:surety)
      end
    end
    steps << step_name(:membership) unless memberships.active.any?
    steps
  end
  
  def ready_to_activate_account?
    sured? && memberships.any?
  end
  
  def revalidate!
    if sureties.active.any? && memberships.active.any?
      sured? || sure!
    else
      active? || unsure!
    end
  end
  
  def sure!
    transaction do
      _sure!
      accounts.where(project_id: owned_project_ids).each &:activate!
    end
  end
  
  def unsure!
    transaction do
      _unsure!
      accounts.non_closed.each do |account|
        account.send(account.requested? ? :decline! : :cancel! )
      end
    end
  end
  
  def close!
    transaction do
      owned_projects.non_closed.each &:close!
      sureties.non_closed.each &:close!
      memberships.non_closed.each &:close!
      tickets.non_closed.each &:close!
      credentials.non_closed.each &:close!
      _close!
    end
  end
  
  def activation_pending?
    activation_state == 'pending'
  end
  
  def activation_active?
    activation_state == 'active'
  end
  
private
  
  def step_name(name)
    I18n.t("steps.#{name}.html").html_safe
  end
  
  def assign_token
    self.token = Digest::SHA1.hexdigest(rand.to_s)
  end
  
  def create_relations
    Project.all.each do |project|
      accounts.where(project_id: project.id).first_or_create!
    end
  end
end
