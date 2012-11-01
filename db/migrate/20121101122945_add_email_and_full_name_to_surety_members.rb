class AddEmailAndFullNameToSuretyMembers < ActiveRecord::Migration
  def change
    add_column :surety_members, :email, :string
    add_column :surety_members, :full_name, :string
  end
end
