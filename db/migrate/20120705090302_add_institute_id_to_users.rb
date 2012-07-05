class AddInstituteIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :institute_id, :integer
  end
end
