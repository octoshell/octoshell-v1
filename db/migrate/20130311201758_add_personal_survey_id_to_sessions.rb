class AddPersonalSurveyIdToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :personal_survey_id, :integer
  end
end
