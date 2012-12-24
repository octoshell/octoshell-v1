class RemoveEnAreaFromReportProjects < ActiveRecord::Migration
  def up
    remove_column :report_projects, :en_area
  end

  def down
    add_column :report_projects, :en_area, :string
  end
end
