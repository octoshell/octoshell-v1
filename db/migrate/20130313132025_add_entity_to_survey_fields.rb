class AddEntityToSurveyFields < ActiveRecord::Migration
  def change
    add_column :survey_fields, :entity, :string
    remove_column :survey_fields, :collection_sql
  end
end
