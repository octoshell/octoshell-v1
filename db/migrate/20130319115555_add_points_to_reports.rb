class AddPointsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :illustration_points, :integer
    add_column :reports, :summary_points, :integer
    add_column :reports, :statement_points, :integer
  end
end
