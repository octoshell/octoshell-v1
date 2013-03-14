class AddReferenceIdToSurveyValues < ActiveRecord::Migration
  def change
    add_column :survey_values, :reference_id, :integer
    add_index :survey_values, [:survey_field_id, :reference_id]
  end
end
