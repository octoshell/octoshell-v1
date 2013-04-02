class AddOwnerToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :owner, :boolean, default: false
  end
end
