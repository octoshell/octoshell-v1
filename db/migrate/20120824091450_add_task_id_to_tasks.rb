class AddTaskIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_id, :integer
    add_index :tasks, :task_id
  end
end
