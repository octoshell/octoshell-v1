class AddCountersSurveyIdToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :counters_survey_id, :integer
  end
end
