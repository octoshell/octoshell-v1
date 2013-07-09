class CreateDeliveredMails < ActiveRecord::Migration
  def change
    create_table :delivered_mails do |t|
      t.integer :user_id
      t.string :subject
      t.text :body
      t.timestamp :created_at
    end
    
    add_index :delivered_mails, :user_id
  end
end
