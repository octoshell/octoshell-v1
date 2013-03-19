class AddRequiredToSurveyFields < ActiveRecord::Migration
  def change
    add_column :survey_fields, :required, :boolean, default: false
  end
end
