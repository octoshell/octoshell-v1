class ChangeTasksCommentToText < ActiveRecord::Migration
  def change
    change_column :tasks, :comment, :text
  end
end
