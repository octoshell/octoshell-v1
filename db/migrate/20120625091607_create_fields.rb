class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :code
      t.string :model_type
      t.integer :position, :default => 1
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
