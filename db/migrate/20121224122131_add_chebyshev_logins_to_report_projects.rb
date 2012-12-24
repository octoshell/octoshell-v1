class AddChebyshevLoginsToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :chebyshev_logins, :text
  end
end
