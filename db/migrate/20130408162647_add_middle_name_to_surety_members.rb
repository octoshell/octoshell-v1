class AddMiddleNameToSuretyMembers < ActiveRecord::Migration
  def change
    add_column :surety_members, :middle_name, :string
  end
end
