# coding: utf-8
class Report < ActiveRecord::Base
  attr_accessor :validate_part, :allow_event

  # belongs_to :project
  belongs_to :user
  has_many :projects, dependent: :destroy, order: 'report_projects.id asc'
  has_many :organizations, dependent: :destroy
  has_one :personal_data, dependent: :destroy
  has_one :personal_survey, dependent: :destroy
  has_many :replies
  has_many :comments
  has_one :ticket
  belongs_to :expert, class_name: :User

  has_paper_trail

  accepts_nested_attributes_for :personal_data, :organizations, :personal_survey,
    :projects
  attr_accessible :personal_data_attributes,
    :organizations_attributes, :personal_survey_attributes, :projects_attributes
  attr_accessible :allow_event, :superviser_comment, as: :admin

  state_machine initial: :editing do
    state :editing
    state :submitted

    after_transition on: :submit do |report, transition|
      report.submitted_at || report.touch(:submitted_at)
      if report.late?
        report.allowed? || report.notify_superviser
      else
        report.allowed? || report.update_attribute(:allow_state, 'allowed')
      end
      if report.expert
        report.begin_assessing!
        Mailer.report_submitted(report).deliver if report.allowed?
      end
    end

    after_transition on: :decline do |report, transition|
      Mailer.report_declined(report).deliver
    end

    state :assessing do
      validates :expert, presence: true
    end
    state :assessed do
      validates :expert, presence: true
    end
    event :submit do
      transition editing: :submitted
    end

    event :decline do
      transition :assessing => :editing
    end

    event :begin_assessing do
      transition :submitted => :assessing
    end

    event :assess do
      transition :assessing => :assessed
    end
  end
  
  state_machine :allow_state, initial: :pending do
    state :allowed
    state :disallowed
    
    event :allow do
      transition pending: :allowed
    end
    
    event :disallow do
      transition pending: :disallowed
    end
    
    after_transition on: :allow do |report, transition|
      report.notify_user_about_allow_state
      Mailer.report_submitted(report).deliver if report.expert
    end
    
    after_transition on: :disallow do |report, transition|
      report.notify_user_about_allow_state
    end
  end
  
  scope :allowed, with_allow_state(:allowed)
  scope :submitted, with_state(:submitted)
  scope :available, with_state(:submitted).where(expert_id: nil)
  scope :assessed, with_state(:assessed)
  scope :already_submitted, where("submitted_at is not null")
  scope :latecommers, where("submitted_at >= ?", Date.new(2013, 2, 4))
  scope :picked, where("expert_id is not null")
  
  def organization
    ::Organization.find(organizations.first.organization_id)
  end

  def expert_name(user_id)
    user_ids = (replies + comments).map(&:user_id).uniq
    user_ids.delete(self[:user_id])
    if n = user_ids.index { |id| id == user_id }
      I18n.t('expert', n: n.next)
    else
      I18n.t('user')
    end
  end

  def setup_defaults!
    create_default_personal_data
    create_default_organizations
    create_default_personal_survey
    create_default_projects
  end

  def create_default_personal_data
    create_personal_data! do |d|
      d.first_name  = user.first_name
      d.last_name   = user.last_name
      d.middle_name = user.middle_name
      d.email       = user.email
    end
  end

  def create_default_organizations
    user.memberships.each do |membership|
      organizations.create! do |org|
        org.organization_id = membership.organization.id
        org.subdivision = ""
        org.other_position = membership.positions.where(name: "Должность").first.try(:value)
      end
    end
    organizations.create! if organizations.empty?
  end

  def create_default_personal_survey
    create_personal_survey!
  end

  def create_default_projects
    projects.create! and return if user.all_projects.empty? || projects.any?
    user.all_projects.each do |project|
      projects.create! do |p|
        p.ru_title     = project.name 
        p.ru_author    = project.accounts.active.map { |a| a.user.full_name }.join(', ')
        p.emails       = project.accounts.active.map { |a| a.user.email }.join(', ')
        p.ru_driver    = project.description
        p.ru_strategy  = ""
        p.ru_objective = ""
        p.ru_impact    = ""
        p.ru_usage     = ""
      end
    end
    projects.create! if projects.empty?
  end

  def completely_valid?
    [ projects.to_a,
      organizations.to_a,
      personal_data,
      personal_survey ].flatten.all?(&:valid?)
  end

  def link_name
    projects.any? ? projects.map(&:ru_title).join(', ') : I18n.t("report", id: id)
  end
  
  def build_support_ticket(attributes = {})
    build_ticket do |t|
      t.user = expert
      t.subject = "Проблема с отчетом ##{id}"
      t.message = attributes[:message]
      t.url = "/admin/reports/#{id}"
      t.ticket_question_id = 11
      t.ticket_field_values.build do |v|
        v.ticket_field_relation_id = 93
        v.value = "/admin/reports/#{id}/review"
      end
    end
  end
  
  def late?
    !submitted_at or submitted_at.to_date >= Date.new(2013, 2, 4)
  end
  
  def choose_allow_state
    if allow_event.in? %w(allow disallow)
      send(allow_event)
    end
  end
  
  def notify_superviser
    Group.find_by_name("paper managers").users.each do |user|
      Mailer.superviser_required(self, user).deliver
    end
  end
  
  def notify_user_about_allow_state
    Mailer.notify_about_allow_state(self).deliver
  end
end
