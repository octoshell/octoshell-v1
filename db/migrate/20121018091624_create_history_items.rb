class CreateHistoryItems < ActiveRecord::Migration
  def change
    create_table :history_items do |t|
      t.integer :user_id
      t.text :data
      t.string :kind
      t.timestamp :created_at
    end
    
    add_index :history_items, :user_id
    add_index :history_items, :kind
  end
end
