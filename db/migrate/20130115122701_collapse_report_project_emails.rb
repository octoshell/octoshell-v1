class CollapseReportProjectEmails < ActiveRecord::Migration
  def change
    rename_column :report_projects, :ru_email, :emails
    remove_column :report_projects, :en_email
  end
end
