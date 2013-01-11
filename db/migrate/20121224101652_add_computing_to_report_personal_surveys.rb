class AddComputingToReportPersonalSurveys < ActiveRecord::Migration
  def change
    add_column :report_personal_surveys, :computing, :text
  end
end
