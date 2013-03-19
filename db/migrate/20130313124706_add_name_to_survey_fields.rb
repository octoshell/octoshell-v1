class AddNameToSurveyFields < ActiveRecord::Migration
  def change
    add_column :survey_fields, :name, :string
  end
end
