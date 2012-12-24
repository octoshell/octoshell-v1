class RemoveRuAreaFromReportProjects < ActiveRecord::Migration
  def up
    remove_column :report_projects, :ru_area
  end

  def down
    add_column :report_projects, :ru_area, :string
  end
end
