class AddAwardsCountToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :awards_count, :integer, default: 0
  end
end
