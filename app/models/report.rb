# coding: utf-8
class Report < ActiveRecord::Base
  # belongs_to :project
  belongs_to :user
  has_many :projects, dependent: :destroy, validate: true
  has_many :organizations, dependent: :destroy
  has_one :personal_data, dependent: :destroy
  has_one :personal_survey, dependent: :destroy

  scope :not_selected, where(expert_id: nil)
  scope :self_selected, lambda { |u| where(expert_id: u.id) }
  scope :rated, where("illustrations_points is not null or statement_points is not null or summary_points is not null")

  accepts_nested_attributes_for :personal_data, :organizations, :personal_survey,
    :projects
  attr_accessible :personal_data_attributes,
    :organizations_attributes, :personal_survey_attributes, :projects_attributes

  state_machine initial: :editing do
    state :editing
    state :submitted
    event :submit do
      transition :editing => :submitted
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
        p.ru_email     = project.accounts.active.map { |a| a.user.email }.join(', ')
        p.ru_driver    = project.description
        p.ru_strategy  = ""
        p.ru_objective = ""
        p.ru_impact    = ""
        p.ru_usage     = ""
      end
    end
    projects.create! if projects.empty?
  end
end
