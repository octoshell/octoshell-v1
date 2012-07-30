class LinkAccessToClusterUser < ActiveRecord::Migration
  def up
    remove_column :accesses, :project_id
    remove_column :accesses, :cluster_id
    add_column :accesses, :cluster_user_id, :integer
  end

  def down
    add_column :accesses, :project_id, :integer
    add_column :accesses, :cluster_id, :integer
    remove_column :accesses, :cluster_user_id
  end
end
