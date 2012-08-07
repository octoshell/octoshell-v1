class AddCallbacksPerformedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :callbacks_performed, :boolean, default: false
  end
end
