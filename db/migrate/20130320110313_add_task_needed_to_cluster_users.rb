class AddTaskNeededToClusterUsers < ActiveRecord::Migration
  def change
    add_column :cluster_users, :task_needed, :boolean, default: false
  end
end
