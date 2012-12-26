# coding: utf-8
class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :projects
  has_many :organizations
  has_one :personal_data
  has_one :personal_survey

  accepts_nested_attributes_for :personal_data, :organizations, :personal_survey,
    :projects
  attr_accessible :personal_data_attributes,
    :organizations_attributes, :personal_survey_attributes, :projects_attributes

  def setup_defaults!
    build_default_personal_data unless personal_data
    build_default_organizations if organizations.empty?
    build_default_personal_survey unless personal_survey
    build_default_projects if projects.empty?
  end

  def build_default_personal_data
    build_personal_data do |d|
      d.first_name = user.first_name
      d.last_name = user.last_name
      d.middle_name = user.middle_name
    end
  end

  def build_default_organizations
    user.memberships.each do |membership|
      organizations.build do |org|
        org.name = membership.organization.name
        org.subdivision = ""
        org.position = membership.positions.where(name: "Должность").first.try(:value)
      end
    end
  end

  def build_default_personal_survey
    build_personal_survey
  end

  def build_default_projects
    projects.build and return if user.all_projects.empty? || projects.any?
    user.all_projects.each do |project|
      projects.build do |p|
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
  end
end
