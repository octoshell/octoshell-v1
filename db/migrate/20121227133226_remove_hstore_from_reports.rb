class RemoveHstoreFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :points
    add_column :reports, :illustrations_points, :integer
    add_column :reports, :statement_points, :integer
    add_column :reports, :summary_points, :integer
  end
end
