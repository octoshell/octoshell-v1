class AddUsernameToClusterUsers < ActiveRecord::Migration
  def change
    add_column :cluster_users, :username, :string
  end
end
