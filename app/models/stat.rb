class Stat < ActiveRecord::Base
  belongs_to :session
  belongs_to :survey_field, class_name: :'Survey::Field'
  
  validates :session, :survey_field, presence: true
  
  attr_accessible :group_by, :session_id, :survey_field_id, :weight, as: :admin
  
  scope :sorted, order('stats.weight asc')
  
  # returns [[name, count], ...]
  def graph_data
    case group_by.to_sym
    when :count then
      user_surveys.map do |us|
        us.find_value(survey_field_id)
      end.group_by(&:to_s).map { |k, v| [k, v.size] }
    end
  end
  
  def user_surveys
    UserSurvey.with_state(:submitted).where(survey_id: survey_field.survey_id)
  end
end
