class AddProjectIdToUserSurveys < ActiveRecord::Migration
  def change
    add_column :user_surveys, :project_id, :integer
    add_index :user_surveys, :project_id
    remove_index :user_surveys, [:user_id, :survey_id]
    add_index :user_surveys, [:user_id, :survey_id, :project_id], unique: true
  end
end
