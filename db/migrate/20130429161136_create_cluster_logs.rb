class CreateClusterLogs < ActiveRecord::Migration
  def change
    create_table :cluster_logs do |t|
      t.integer :cluster_id
      t.string :message
    end
    add_index :cluster_logs, [:cluster_id, :id]
  end
end
