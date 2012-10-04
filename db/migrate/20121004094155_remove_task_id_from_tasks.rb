class RemoveTaskIdFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :task_id
  end

  def down
    add_column :tasks, :task_id, :integer
  end
end
