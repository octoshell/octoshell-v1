class Survey < ActiveRecord::Base
  belongs_to :session
  has_many :fields
  
  def name
    case id
    when session.personal_survey_id then
      I18n.t('user_survey.personal')
    when session.projects_survey_id then
      I18n.t('user_survey.projects')
    when session.counters_survey_id then
      I18n.t('user_survey.counters')
    end
  end
  
  def session
    Session.where(%{
      personal_survey_id = :id or
      projects_survey_id = :id or
      counters_survey_id = :id}, id: id).first!
  end
end
