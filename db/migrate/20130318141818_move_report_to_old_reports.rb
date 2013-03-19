class MoveReportToOldReports < ActiveRecord::Migration
  def change
    %w(report_comments report_organizations report_personal_data
      report_personal_surveys report_projects report_replies reports).each do |t|
      name = t.to_sym
      rename_table name, :"old_#{name}"
    end
  end
end
