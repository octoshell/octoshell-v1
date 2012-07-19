class User < ActiveRecord::Base
  acts_as_paranoid
  
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
  
  validates :first_name, :last_name, :email, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, on: :update, if: :password?
  validates :email, uniqueness: true
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :admin, as: :admin
  
  scope :admins, where(admin: true)
  
  def all_requests
    Request.joins(project: :accounts).where(accounts: { user_id: id })
  end
  
  def all_accounts
    Account.where(project_id: project_ids)
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
  
  def active?
    activation_state == 'active'
  end
  
  def sured?
    sureties.active.exists?
  end
  
  def start_steps
    project_steps
  end
  
  def request_steps
    steps = []
    steps << step_name(:project) unless owned_projects.any?
    steps << step_name(:surety) unless sured?
    steps << step_name(:membership) unless memberships.any?
    steps
  end
  
  def project_steps
    steps = []
    steps << step_name(:surety) unless sured?
    steps << step_name(:membership) unless memberships.any?
    steps
  end
  
private
  
  def step_name(name)
    I18n.t("steps.#{name}.html").html_safe
  end
  
end
