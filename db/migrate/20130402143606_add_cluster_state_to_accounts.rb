class AddClusterStateToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :cluster_state, :string
    add_index :accounts, :cluster_state
    add_index :accounts, :access_state
  end
end
