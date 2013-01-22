# coding: utf-8
class Report < ActiveRecord::Base
  attr_accessor :validate_part

  # belongs_to :project
  belongs_to :user
  has_many :projects, dependent: :destroy, order: 'report_projects.id asc'
  has_many :organizations, dependent: :destroy
  has_one :personal_data, dependent: :destroy
  has_one :personal_survey, dependent: :destroy
  has_many :replies
  has_many :comments
  belongs_to :expert, class_name: :User

  has_paper_trail

  accepts_nested_attributes_for :personal_data, :organizations, :personal_survey,
    :projects
  attr_accessible :personal_data_attributes,
    :organizations_attributes, :personal_survey_attributes, :projects_attributes

  state_machine initial: :editing do
    state :editing
    state :submitted
    state :assessing do
      validates :expert, presence: true
    end
    state :assessed do
      validates :expert, presence: true
    end
    event :submit do
      transition :editing => :submitted
    end

    event :begin_assessing do
      transition :submitted => :assessing
    end

    event :assess do
      transition :assessing => :assessed
    end
  end

  scope :submitted, with_state(:submitted)
  scope :assessed, with_state(:assessed)

  def organization
    ::Organization.find(organizations.first.organization_id)
  end

  def expert_name(user_id)
    n = (replies + comments).map(&:user_id).uniq.index { |id| id == user_id }.next
    I18n.t('expert', n: n)
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
    I18n.t("report", id: id)
  end
end
