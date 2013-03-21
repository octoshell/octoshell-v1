class AddTaskNeededToAccesses < ActiveRecord::Migration
  def change
    add_column :accesses, :task_needed, :boolean, default: false
  end
end
