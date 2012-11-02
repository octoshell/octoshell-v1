class AddAccountCodeIdToSuretyMembers < ActiveRecord::Migration
  def change
    add_column :surety_members, :account_code_id, :integer
  end
end
