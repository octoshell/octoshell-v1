class AddFieldsToReportPersonalSurveys < ActiveRecord::Migration
  def change
    change_table :report_personal_surveys do |t|
      t.string :request_technology
      t.string :other_technology
    end
  end
end
