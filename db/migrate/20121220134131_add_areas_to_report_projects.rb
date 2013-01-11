class AddAreasToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :areas, :text
  end
end
