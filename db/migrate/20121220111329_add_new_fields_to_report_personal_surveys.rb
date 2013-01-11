class AddNewFieldsToReportPersonalSurveys < ActiveRecord::Migration
  def change
    change_table :report_personal_surveys do |t|
      t.string :other_compilator
      t.string :other_software
    end
  end
end
