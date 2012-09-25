class AddUserIdToAccountCodes < ActiveRecord::Migration
  def change
    add_column :account_codes, :user_id, :integer
  end
end
