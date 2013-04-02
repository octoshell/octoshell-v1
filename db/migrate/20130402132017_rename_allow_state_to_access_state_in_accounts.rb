class RenameAllowStateToAccessStateInAccounts < ActiveRecord::Migration
  def change
    rename_column :accounts, :allow_state, :access_state
  end
end
