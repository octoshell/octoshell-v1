# Пользователь
class User < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  has_attached_file :avatar
  authenticates_with_sorcery!
  
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
  has_many :tickets
  has_many :additional_emails
  has_many :history_items
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :assessing_reports, class_name: :Report, foreign_key: :expert_id
  has_many :user_surveys
  has_many :faults
  has_and_belongs_to_many :subscribed_tickets, join_table: :tickets_users, class_name: :Ticket, uniq: true
  has_many :delivered_mails
  has_many :notices
  
  validates :first_name, :last_name, :middle_name, :email, :phone, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, on: :update, if: :password?
  validates :email, uniqueness: true
  validates_attachment :avatar, size: { in: 0..150.kilobytes }
  
  before_create :assign_token
  after_create :create_additional_email
  after_create :setup_default_groups
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :avatar, :additional_emails_attributes, :phone, :receive_info_notifications
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_organization, :organization_id,
    :avatar, :additional_emails_attributes, :phone, :receive_info_notifications, :group_ids, as: :admin
  
  accepts_nested_attributes_for :additional_emails, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :groups
  
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
    
    event :sure do
      transition :active => :sured
    end
    
    event :unsure do
      transition :sured => :active
    end
    
    event :close do
      transition [:active, :sured] => :closed
    end
    
    inside_transition :on => :close, &:close_relations!
    inside_transition :on => :sure, &:activate_own_accounts!
    inside_transition :on => :unsure, &:deactivate_own_accounts!
  end
  
  def self.notifications_count
    [ Task.with_state(:failed),
      Ticket.with_state(:active),
      Surety.with_state(:generated),
      Request.with_state(:pending) ].map(&:count).sum
  end
  
  def self.superadmins
    Group.superadmins.users
  end
  
  def self.experts
    Group.experts.users
  end
  
  def new_notice(page)
    un = nil
    res = ::Notice.active.find do |notice|
      if un = notices.where(notice_id: notice.id).first
        reg = %r{#{notice.url}} rescue /1/
        un.pending? && page =~ reg
      end
    end
    
    res && un
  end
  
  def examine!(id)
    session = Session.find(id)
    user_surveys.where(survey_id: session.survey_ids).each do |s|
      faults.create! do |fault|
        fault.kind = "custom"
        fault.kind_of_block = "user"
        fault.description = "Не отправлен опрос ##{s.id}"
      end unless s.submitted?
    end
    reports.where(session_id: session.id).each do |r|
      faults.create! do |fault|
        fault.kind = "custom"
        fault.kind_of_block = "user"
        fault.description = "Не отправлен отчет ##{r.id}"
      end unless r.passed?
    end
    nil
  end
  
  def reports
    Report.where(project_id: owned_project_ids)
  end
  
  def session_status
    status = :not_sent
    if current_session_surveys.all?(&:submitted?)
      if current_session_reports.empty? || current_session_reports.all?(&:assessed?)
        status = :successed
      else
        status = :pending
      end
    end
    status
  end
  
  def current_session_surveys
    if session = Session.current
      user_surveys.where(survey_id: session.survey_ids)
    else
      []
    end
  end
  
  def current_session_reports
    if session = Session.current
      reports.where(session_id: Session.current.id)
    else
      []
    end
  end

  def all_sureties
    sureties = Surety.arel_table
    projects = Project.arel_table
    Surety.eager_load(:project).where(sureties[:id].in(surety_ids).or(
                                      projects[:id].in(owned_project_ids)))
  end
  
  def all_projects
    condition = "(accounts.access_state = 'allowed' and accounts.user_id = 
      :id) or projects.user_id = :id"
    ids = Project.joins(:accounts).where(condition, id: id).pluck(:id)
    Project.where(id: ids)
  end
  
  def managed_accounts
    Account.where(project_id: owned_project_ids)
  end
  
  def username
    email.delete(".+_-")[/^(.+)@/, 1]
  end
  
  def password?
    password.present?
  end
  
  def full_name
    [last_name, first_name, middle_name].find_all do |i|
      i.present? && i != '-'
    end.join(' ')
  end

  def initials
    [first_name, middle_name].find_all do |i|
      i.present? && i != '-'
    end.join(' ')
  end
  
  def project_steps
    steps = []
    steps << step_name(:membership) unless memberships.with_state(:active).exists?
    steps << step_name(:credential) unless credentials.with_state(:active).exists?
    steps
  end
  
  def revalidate!
    return if closed?
    conditions = [
      proc { sureties.with_state(:active).any? },
      proc { memberships.with_state(:active).any? },
      proc { faults.where(kind_of_block: "user").with_state(:actual).empty? }
    ]
    if conditions.all?(&:call)
      sured? || sure!
    else
      active? || unsure!
    end
  end
  
  def activation_active?
    activation_state == 'active'
  end
  
  def activation_pending?
    activation_state == 'pending'
  end
  
  def notifications_count
    self.class.notifications_count
  end
  
  def emails
    emails = [email]
    emails << additional_emails.pluck(:email)
    emails.flatten.compact.uniq
  end
  
  def as_json(options)
    if options[:for] == :ajax
      { id: id,
        text: "#{full_name} #{email}",
        email: email,
        first_name: first_name,
        last_name: last_name,
        middle_name: middle_name,
        state: state_name }
    else
      super(options)
    end
  end
  
  def active_clusters
    all_projects.with_state(:active).map do |p|
      p.requests.map(&:cluster)
    end.flatten.uniq
  end
  
  def track!(kind, record, user)
    history_items.create! do |item|
      item.kind = kind
      item.data = record.respond_to?(:attributes) ? record.attributes : record
      item.author_id = user ? user.id : nil
    end
  end

  def link_name
    full_name
  end
  
  def activate_own_accounts!
    accounts.without_cluster_state(:active).each &:activate!
  end
  
  def deactivate_own_accounts!
    accounts.with_cluster_state(:active).each &:close!
  end
  
  def close_relations!
    %w(owned_projects sureties memberships tickets credentials).
      each { |r| send(r).without_state(:closed).each &:close! }
  end
  
  def active_organizations
    memberships.with_state(:active).map(&:organization).uniq.sort_by(&:name)
  end
  
  def unsuccessful_sessions
    Session.all.find_all do |s|
      (reports.where(session_id: s.id).any? && reports.where(session_id: s.id).any? { |r| !r.passed? }) || 
        user_surveys.where(survey_id: s.survey_ids).without_state(:submitted).any?
    end
  end
  
private
  
  def step_name(name)
    I18n.t("steps.#{name}.html").html_safe
  end
  
  def assign_token
    self.token = Digest::SHA1.hexdigest(rand.to_s)
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
