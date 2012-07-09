class RemoveCompanyIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :institute_id
  end

  def down
    add_column :users, :institute_id, :integer
  end
end
