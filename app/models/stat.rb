class Stat < ActiveRecord::Base
  GROUPS_BY = [:count]
  
  belongs_to :session
  belongs_to :survey_field, class_name: :'Survey::Field'
  belongs_to :organization
  
  validates :session, :survey_field, :group_by, presence: true
  validates :organization, presence: true, if: proc { |s| s.group_by == 'subdivisions' }
  
  attr_accessible :group_by, :session_id, :survey_field_id, :organization_id,
    :weight, as: :admin
  
  scope :sorted, order('stats.weight asc')
  
  serialize :cache, Array
  
  # returns [[name, count], ...]
  def graph_data
    data = cache? ? cache : send("graph_data_for_#{group_by}")
    data.extend(Chartable)
  end
  
  def cache!
    self.cache = graph_data
    save!
  end
  
  def graph_data_for_count
    user_surveys.map do |us|
      us.find_value(survey_field_id).value
    end.group_by(&:to_s).map { |k, v| [k, v.size] }
  end
  
  def graph_data_for_organization_kinds
    grouped_organizations_by_kind.map do |kind, organizations|
      [kind.name, organizations.size]
    end
  end
  
  def graph_data_for_subdivisions
    grouped_organization_memberships.map do |subdivision, memberships|
      [subdivision.try(:graph_name) || 'blank', memberships.size]
    end
  end
  
  def user_surveys
    UserSurvey.with_state(:submitted).where(survey_id: survey_field.survey_id)
  end
  
  def grouped_organization_memberships
    organization.memberships.group_by(&:subdivision)
  end
  
  def grouped_organizations_by_kind
    session.reports.map { |r| r.project.organization }.group_by do |org|
      org.organization_kind
    end
  end
end
