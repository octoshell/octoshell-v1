class AddReferenceTypeToSurveyFields < ActiveRecord::Migration
  def change
    add_column :survey_fields, :reference_type, :string
  end
end
