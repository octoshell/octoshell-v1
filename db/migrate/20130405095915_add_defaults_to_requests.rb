class AddDefaultsToRequests < ActiveRecord::Migration
  def change
    change_column_default :requests, :cpu_hours, 0
    change_column_default :requests, :gpu_hours, 0
  end
end
