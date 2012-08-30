class AddStateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :state, :string
    remove_column :tasks, :success
  end
end
