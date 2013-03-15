class AddHintToSurveyFields < ActiveRecord::Migration
  def change
    add_column :survey_fields, :hint, :string
  end
end
