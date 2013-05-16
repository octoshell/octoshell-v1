class FixIndexOnSurveyValues < ActiveRecord::Migration
  def change
    remove_index :survey_values, name: :index_survey_values_on_survey_field_id_and_user_id
  end
end
