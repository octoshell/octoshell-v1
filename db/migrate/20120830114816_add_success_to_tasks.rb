class AddSuccessToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :success, :boolean
  end
end
