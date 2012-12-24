class AddCommentToReportPersonalSurveys < ActiveRecord::Migration
  def change
    add_column :report_personal_surveys, :comment, :text
  end
end
