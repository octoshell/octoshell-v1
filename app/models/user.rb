class User < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  has_attached_file :avatar
  
  authenticates_with_sorcery!
  
  attr_reader :new_organization
  attr_reader :organization_id
  
  has_many :accounts, inverse_of: :user
  has_many :credentials
  has_many :requests
  has_many :owned_projects, class_name: :Project
  has_many :projects, through: :accounts
  has_many :memberships
  has_many :membershiped_organizations, through: :memberships, source: :organization
  has_many :sureties
  has_many :organizations, through: :sureties
  has_many :accesses, through: :credentials
  has_many :tickets
  has_many :additional_emails
  has_many :history_items
  
  validates :first_name, :last_name, :middle_name, :email, :phone, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, on: :update, if: :password?
  validates :email, uniqueness: true
  validates_attachment :avatar, size: { in: 0..150.kilobytes }
  
  before_create :assign_token
  after_create :create_relations
  after_create :create_additional_email
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :avatar, :additional_emails_attributes
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :admin, :avatar, :additional_emails_attributes, as: :admin
  
  accepts_nested_attributes_for :additional_emails, allow_destroy: true, reject_if: :all_blank
  
  scope :admins, where(admin: true)
  scope :finder, (lambda do |q|
    where "last_name like :q or first_name like :q or email like :q", q: "%#{q}%"
  end)
  
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
  
  def all_projects
    projects.where("accounts.state = 'active' or projects.user_id = ?", id)
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
    [first_name, middle_name, last_name].find_all do |i|
      i.present? && i != '-'
    end.join(' ')
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
    return steps if admin?
    
    if !sureties.active.exists?
      if sureties.pending.exists?
        steps << step_name(:send_and_wait_approve)
      else
        steps << step_name(:surety)
      end
    end
    steps << step_name(:membership) unless memberships.active.exists?
    steps << step_name(:credential) unless credentials.active.exists?
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
      accounts.where(project_id: owned_projects.active.map(&:id)).each &:activate!
    end
  end
  
  def unsure!
    transaction do
      _unsure!
      accounts.non_closed.each &:cancel!
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
  
  def notifications_count
    count = 0
    
    if admin?
      count += Task.failed.count
      count += Ticket.active.count
      count += Surety.pending.count
      count += Request.pending.count
    else
      count += sureties.pending.count
      count += requests.pending.count
      count += tickets.answered.count
    end
    
    count
  end
  
  def emails
    emails = [email]
    emails << additional_emails.pluck(:email)
    emails.flatten.compact.uniq
  end
  
  def produces_account_codes
    AccountCode.where(project_id: owned_project_ids)
  end
  
  def avatar_url
    if avatar?
      avatar.url
    else
      host = Rails.application.config.action_mailer.default_url_options[:host]
      Gravatar.new(email).image_url + '?' + {
        s: '116',
        d: "http://#{host}/assets/default_avatar.png"
      }.to_param
    end
  end
  
  def as_json(options)
    { id: id, text: "#{full_name} #{email}" }
  end
  
  def active_clusters
    all_projects.active.map do |p|
      p.requests.map(&:cluster)
    end.flatten.uniq
  end
  
  def track!(kind, record, user)
    history_items.create! do |item|
      item.kind = kind
      item.data = record.attributes
      item.author_id = user ? user.id : nil
    end
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
  
  def create_additional_email
    additional_emails.create! do |additional_email|
      additional_email.email = email
    end
  end
end
