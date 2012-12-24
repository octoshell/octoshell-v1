class AddComputingSystemsToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :computing_systems, :text
  end
end
