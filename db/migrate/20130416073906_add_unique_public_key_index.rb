class AddUniquePublicKeyIndex < ActiveRecord::Migration
  def change
    remove_index :credentials, :public_key
    add_index :credentials, :public_key, unique: true
  end
end
