class AddFieldsToUserSurveys < ActiveRecord::Migration
  def change
    add_column :user_surveys, :user_id, :integer
    add_column :user_surveys, :survey_id, :integer
    add_index :user_surveys, :user_id
    add_index :user_surveys, :survey_id
    add_index :user_surveys, [:user_id, :survey_id], unique: true
  end
end
