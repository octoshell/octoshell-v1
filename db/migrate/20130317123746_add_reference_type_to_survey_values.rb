class AddReferenceTypeToSurveyValues < ActiveRecord::Migration
  def change
    add_column :survey_values, :reference_type, :string
  end
end
