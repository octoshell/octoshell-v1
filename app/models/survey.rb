class Survey < ActiveRecord::Base
  has_many :fields
  
  def session
    Session.where(%{
      personal_survey_id = :id or
      projects_survey_id = :id or
      counters_survey_id = :id}, id: id).first!
  end
end
