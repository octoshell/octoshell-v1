class AddStateToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :state, :string
  end
end
