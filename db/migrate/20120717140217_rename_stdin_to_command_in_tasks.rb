class RenameStdinToCommandInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :stdin, :command
  end
end
