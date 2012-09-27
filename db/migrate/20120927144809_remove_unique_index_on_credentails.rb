class RemoveUniqueIndexOnCredentails < ActiveRecord::Migration
  def change
    remove_index :credentials, [:user_id, :public_key]
  end
end
