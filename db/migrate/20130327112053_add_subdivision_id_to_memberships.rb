class AddSubdivisionIdToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :subdivision_id, :integer
    add_index :memberships, :subdivision_id
  end
end
