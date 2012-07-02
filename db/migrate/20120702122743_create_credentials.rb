class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.text :public_key
      t.references :user
      t.timestamp :deleted_at
      t.timestamps
    end
    
    add_index :credentials, :public_key
    add_index :credentials, [:public_key, :user_id], unique: true
  end
end
