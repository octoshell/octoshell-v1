class CreateUserNotices < ActiveRecord::Migration
  def change
    create_table :user_notices do |t|
      t.integer  :user_id
      t.integer :notice_id
      t.string :state
      t.timestamps
    end
    
    add_index :user_notices, :user_id
    add_index :user_notices, [:user_id, :state]
    add_index :user_notices, [:notice_id, :state]
    add_index :user_notices, :notice_id
    add_index :user_notices, [:notice_id, :user_id], unique: true
  end
end
