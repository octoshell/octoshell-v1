class CreateFaultReplies < ActiveRecord::Migration
  def change
    create_table :fault_replies do |t|
      t.integer :fault_id
      t.text :message
      t.integer :user_id
      t.timestamps
    end
    
    add_index :fault_replies, :fault_id
    add_index :fault_replies, :user_id
  end
end
