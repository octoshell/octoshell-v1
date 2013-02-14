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
  has_many :surety_members, inverse_of: :user
  has_many :sureties, through: :surety_members
  has_many :organizations, through: :sureties
  has_many :accesses, through: :credentials
  has_many :tickets
  has_many :additional_emails
  has_many :history_items
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :reports
  has_many :assessing_reports, class_name: :Report, foreign_key: :expert_id
  has_and_belongs_to_many :subscribed_tickets, join_table: :tickets_users, class_name: :Ticket, uniq: true
  
  validates :first_name, :last_name, :middle_name, :email, :phone, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, on: :update, if: :password?
  validates :email, uniqueness: true
  validates_attachment :avatar, size: { in: 0..150.kilobytes }
  
  before_create :assign_token
  after_create :create_relations
  after_create :create_additional_email
  after_create :setup_default_groups
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :avatar, :additional_emails_attributes, :phone
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :admin, :avatar, :additional_emails_attributes, :phone, :group_ids, as: :admin
  
  accepts_nested_attributes_for :additional_emails, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :groups
  
  scope :admins, where(admin: true).where("users.state != 'closed'")
  scope :finder, (lambda do |q|
    return scoped if q.blank?
    condition = q.split(/\s/).map do |word|
      %w(last_name first_name middle_name email).map do |col|
          sanitize_sql(["lower(#{col}) like '%s'", "%#{word.mb_chars.downcase}%"])
      end.join(' or ')
    end.join (') or (')
    where "(#{condition})"
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
    
    def use_scope(scope)
      s = scoped
      case scope
      when 'sured' then
        s = s.sured
      end
      s
    end

    def admin_notifications_count
      [Task.failed, Ticket.active, Surety.pending, Request.pending].
        sum_of_count
    end
  end

  def report
    reports.first || begin
      report = reports.create!
      report.setup_defaults!
      report
    end
  end

  def fio
    [last_name, first_name, middle_name].join(' ')
  end

  def abilities
    sort = %{
      (case when available then 1 when available is null then 2 else 3 end) asc
    }
    abilities = Ability.where(group_id: group_ids).order(sort).uniq_by(&:to_definition)
    abilities.any? ? abilities : Ability.default
  end

  def all_sureties
    Surety.where("id in (?) or project_id in (?)", surety_ids, owned_project_ids)
  end
  
  def all_projects
    projects.where("accounts.state = 'active' or projects.user_id = ?", id)
  end

  def managed_accounts
    Account.where(project_id: owned_project_ids)
  end
  
  def new_organization=(attributes)
    if attributes.values.any?(&:present?)
      @new_organization = organizations.build(attributes)
    end
  end

  def username
    email.delete(".+_-")[/^(.+)@/, 1]
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
  
  def project_steps
    steps = []
    return steps if admin?
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
      accounts.closed.where(project_id: owned_projects.active.map(&:id)).
        each &:activate!
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
      [ owned_projects,
        sureties,
        memberships,
        tickets,
        credentials ].each { |relation| relation.non_closed.each &:close! }
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
    admin? ? admin_notifications_count : user_notifications_count
  end
  
  def admin_notifications_count
    self.class.admin_notifications_count
  end
  
  def user_notifications_count
    [sureties.pending, requests.pending, tickets.answered].sum_of_count
  end
  
  def emails
    emails = [email]
    emails << additional_emails.pluck(:email)
    emails.flatten.compact.uniq
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
    if options[:for] == :ajax
      { id: id, text: "#{full_name} #{email}" }
    else
      super(options)
    end
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

  def link_name
    full_name
  end

  def can_cancel_account?(account)
    owned_projects.map(&:account_ids).flatten.include?(account.id)
  end
  
  def mentioned_reports
    Report::Project.where("report_projects.emails like '%#{email}%'").map do |p|
      p.report
    end.uniq
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

  def setup_default_groups
    user_groups.where(group_id: Group.authorized.id).first_or_create!
    true
  end
end
