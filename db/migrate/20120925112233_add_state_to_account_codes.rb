class AddStateToAccountCodes < ActiveRecord::Migration
  def change
    add_column :account_codes, :state, :string
  end
end
