class AddAllowStateToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :allow_state, :string
  end
end
