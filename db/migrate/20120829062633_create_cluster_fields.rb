class CreateClusterFields < ActiveRecord::Migration
  def change
    create_table :cluster_fields do |t|
      t.integer :cluster_id
      t.string :name
    end
    
    add_index :cluster_fields, :cluster_id
  end
end
