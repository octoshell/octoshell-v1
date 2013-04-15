class AddGroupNameToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :group_name, :string
  end
end
