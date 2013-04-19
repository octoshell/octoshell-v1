class AddUniqueIndexOnAccountUsernamesWithClusters < ActiveRecord::Migration
  def change
    add_index :accounts, :username, unique: true
  end
end
