class AddUserSurveyIdSurveyValues < ActiveRecord::Migration
  def up
    add_column :survey_values, :user_survey_id, :integer
    add_index :survey_values, :user_survey_id
    add_index :survey_values, [:user_survey_id, :survey_field_id], unique: true
  end

  def down
    remove_column :survey_values, :user_survey_id
  end
end
