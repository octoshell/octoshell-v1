class AddCriticalTechnologiesToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :critical_technologies, :text
  end
end
