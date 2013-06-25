require "csv"
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
    survey_values.group_by(&:to_s).map { |k, v| [k, v.size] }.
      sort_by(&:last).reverse
  end
  
  def survey_values
    user_surveys = UserSurvey.select(:id).with_state(:submitted).where(survey_id: session.survey_ids).to_sql
    raw_survey_values.map(&:value).flatten.find_all(&:present?)
  end
  
  def users_with_value(value)
    raw_survey_values.find_all do |sv|
      Array(sv.value).flatten.map(&:to_s).include?(value)
    end.map(&:user).uniq.sort_by(&:full_name)
  end
  
  def raw_survey_values
    user_surveys = UserSurvey.select(:id).with_state(:submitted).where(survey_id: session.survey_ids).to_sql
    Survey::Value.includes(:field).where("user_survey_id in (#{user_surveys})").
      where(survey_field_id: survey_field_id)
  end
  
  def title
    "#{survey_field.name} по количеству"
  end
  
  def to_csv
    CSV.generate(col_sep: ";") do |csv|
      graph_data.each do |row|
        csv << row
      end
    end
  end
end
