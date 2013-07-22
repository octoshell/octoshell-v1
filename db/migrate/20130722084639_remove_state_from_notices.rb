class RemoveStateFromNotices < ActiveRecord::Migration
  def up
    remove_column :notices, :state
  end

  def down
    add_column :notices, :state, :string
  end
end
