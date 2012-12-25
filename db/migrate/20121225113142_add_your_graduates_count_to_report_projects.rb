class AddYourGraduatesCountToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :graduates_count, :integer
  end
end
