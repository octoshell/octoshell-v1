class RemovePublicizedFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :publicized
  end

  def down
    add_column :users, :publicized, :boolean
  end
end
