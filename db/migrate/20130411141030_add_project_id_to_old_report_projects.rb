class AddProjectIdToOldReportProjects < ActiveRecord::Migration
  def change
    add_column :old_report_projects, :project_id, :integer
  end
end
