class AddLomonosovLoginsToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :lomonosov_logins, :text
  end
end
