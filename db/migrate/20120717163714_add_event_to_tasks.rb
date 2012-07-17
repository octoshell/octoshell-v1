class AddEventToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :event, :string
  end
end
