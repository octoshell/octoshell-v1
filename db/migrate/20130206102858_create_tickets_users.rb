class CreateTicketsUsers < ActiveRecord::Migration
  def change
    create_table :tickets_users, id: false do |t|
      t.integer :user_id
      t.integer :ticket_id
    end
    
    add_index :tickets_users, :ticket_id
    add_index :tickets_users, :user_id
    add_index :tickets_users, [:ticket_id, :user_id], unique: true
  end
end
