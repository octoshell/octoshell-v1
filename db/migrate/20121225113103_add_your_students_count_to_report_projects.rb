class AddYourStudentsCountToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :your_students_count, :integer
  end
end
