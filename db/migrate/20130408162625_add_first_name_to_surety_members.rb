class AddFirstNameToSuretyMembers < ActiveRecord::Migration
  def change
    add_column :surety_members, :first_name, :string
  end
end
