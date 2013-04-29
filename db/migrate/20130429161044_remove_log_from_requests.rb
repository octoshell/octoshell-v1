class RemoveLogFromRequests < ActiveRecord::Migration
  def up
    remove_column :requests, :log
  end

  def down
    add_column :requests, :log, :text
  end
end
