class AddTaskNeededToClusterProjects < ActiveRecord::Migration
  def change
    add_column :cluster_projects, :task_needed, :boolean, default: false
  end
end
