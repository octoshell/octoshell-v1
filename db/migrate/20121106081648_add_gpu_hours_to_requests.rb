class AddGpuHoursToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :gpu_hours, :integer, default: 0
    rename_column :requests, :hours, :cpu_hours
  end
end
