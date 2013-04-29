class AddCreatedAtToClusterLogs < ActiveRecord::Migration
  def change
    add_column :cluster_logs, :created_at, :timestamp
  end
end
