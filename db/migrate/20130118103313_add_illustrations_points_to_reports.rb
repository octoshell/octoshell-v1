class AddIllustrationsPointsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :illustrations_points, :integer
  end
end
