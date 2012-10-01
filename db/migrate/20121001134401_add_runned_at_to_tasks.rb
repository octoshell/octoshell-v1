class AddRunnedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :runned_at, :datetime
  end
end
