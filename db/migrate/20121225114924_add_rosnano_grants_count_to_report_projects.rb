class AddRosnanoGrantsCountToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :rosnano_grants_count, :integer
  end
end
