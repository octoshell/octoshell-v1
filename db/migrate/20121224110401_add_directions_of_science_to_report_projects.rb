class AddDirectionsOfScienceToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :directions_of_science, :text
  end
end
