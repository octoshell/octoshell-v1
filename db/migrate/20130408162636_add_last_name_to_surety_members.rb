class AddLastNameToSuretyMembers < ActiveRecord::Migration
  def change
    add_column :surety_members, :last_name, :string
  end
end
