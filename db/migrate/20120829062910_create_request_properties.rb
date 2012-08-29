class CreateRequestProperties < ActiveRecord::Migration
  def change
    create_table :request_properties do |t|
      t.string :name
      t.string :value
      t.integer :request_id
    end
    
    add_index :request_properties, :request_id
  end
end
