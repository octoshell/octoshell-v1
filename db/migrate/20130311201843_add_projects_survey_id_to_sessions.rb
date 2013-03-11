class AddProjectsSurveyIdToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :projects_survey_id, :integer
  end
end
