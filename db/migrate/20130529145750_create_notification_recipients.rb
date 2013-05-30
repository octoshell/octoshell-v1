class CreateNotificationRecipients < ActiveRecord::Migration
  def change
    create_table :notification_recipients do |t|
      t.integer :notification_id
      t.integer :user_id
      t.string :state
      t.timestamps
    end
    
    add_index :notification_recipients, :notification_id
    add_index :notification_recipients, [:notification_id, :user_id], unique: true
  end
end
