class AddUserIdToUniquePublicKeyIndex < ActiveRecord::Migration
  def change
    remove_index :credentials, :public_key
    add_index :credentials, [:user_id, :public_key], unique: true
  end
end
