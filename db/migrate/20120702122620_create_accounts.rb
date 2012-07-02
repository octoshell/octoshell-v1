class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.references :project
      t.timestamp :deleted_at
      t.timestamps
    end
    
    add_index :accounts, :user_id
    add_index :accounts, :project_id
    add_index :accounts, [:user_id, :project_id], unique: true
  end
end
