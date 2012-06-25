class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.integer :field_id
      t.integer :model_id
      t.integer :model_type
      t.text :value
      t.timestamp :deleted_at
      t.timestamps
    end
    
    add_index :values, [:field_id, :model_id, :model_type], :unique => true
  end
end
