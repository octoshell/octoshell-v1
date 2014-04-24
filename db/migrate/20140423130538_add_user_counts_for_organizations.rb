class AddUserCountsForOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :active_users_count, :integer, default: 0
    add_column :organizations, :sured_users_count, :integer, default: 0
  end
end
