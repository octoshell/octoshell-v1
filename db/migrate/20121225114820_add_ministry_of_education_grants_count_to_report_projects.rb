class AddMinistryOfEducationGrantsCountToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :ministry_of_education_grants_count, :integer
  end
end
