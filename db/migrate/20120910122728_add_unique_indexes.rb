class AddUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :accesses, [:credential_id, :cluster_user_id], unique: true
    add_index :cluster_users, [:cluster_project_id, :account_id], unique: true
    add_index :cluster_projects, [:cluster_id, :project_id], unique: true
  end
end
