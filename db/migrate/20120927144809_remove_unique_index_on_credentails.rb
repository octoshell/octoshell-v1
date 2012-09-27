class RemoveUniqueIndexOnCredentails < ActiveRecord::Migration
  def change
    remove_index :credentials, column: [:public_key, :user_id]
  end
end
