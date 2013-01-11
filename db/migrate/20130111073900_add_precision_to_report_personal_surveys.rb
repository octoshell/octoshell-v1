class AddPrecisionToReportPersonalSurveys < ActiveRecord::Migration
  def change
    add_column :report_personal_surveys, :precision, :text
  end
end
