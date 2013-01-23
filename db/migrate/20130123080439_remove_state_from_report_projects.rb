class RemoveStateFromReportProjects < ActiveRecord::Migration
  def up
    remove_column :report_projects, :state
  end

  def down
    add_column :report_projects, :state, :string
  end
end
