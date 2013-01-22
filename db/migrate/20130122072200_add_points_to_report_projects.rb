class AddPointsToReportProjects < ActiveRecord::Migration
  def change
    change_table :report_projects do |t|
      t.integer  :illustrations_points, default: 0
      t.integer  :statement_points, default: 0
      t.integer  :summary_points, default: 0
    end
  end
end
