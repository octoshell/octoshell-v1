class FixUniqueActiveAccesses < ActiveRecord::Migration
  def up
    remove_index :accesses, [:credential_id, :cluster_id, :project_id]
    add_index :accesses, [:credential_id, :cluster_id, :project_id, :deleted_at], unique: true, name: 'unique_active'
  end

  def down
    remove_index :accesses, name: 'unique_active'
    add_index :accesses, [:credential_id, :cluster_id, :project_id], unique: true
  end
end
