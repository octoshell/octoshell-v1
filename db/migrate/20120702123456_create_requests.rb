class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :project
      t.references :cluster
      t.integer :hours
      t.timestamp :deleted_at
      t.timestamps
    end
    
    add_index :requests, :project_id
    add_index :requests, :cluster_id
  end
end
