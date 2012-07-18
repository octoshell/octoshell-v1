class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.references :credential
      t.references :cluster
      t.references :project
      t.string :state
      t.timestamps
    end
    
    add_index :accesses, [:credential_id, :cluster_id, :project_id], unique: true
  end
end
