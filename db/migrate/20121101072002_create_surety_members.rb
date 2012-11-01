class CreateSuretyMembers < ActiveRecord::Migration
  def change
    create_table :surety_members do |t|
      t.integer :surety_id
      t.integer :user_id
    end
    
    add_index :surety_members, :surety_id
    add_index :surety_members, :user_id
    add_index :surety_members, [:surety_id, :user_id], unique: true
  end
end
