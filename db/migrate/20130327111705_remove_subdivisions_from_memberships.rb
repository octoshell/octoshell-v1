class RemoveSubdivisionsFromMemberships < ActiveRecord::Migration
  def change
    remove_column :memberships, :subdivision
    remove_column :memberships, :short_subdivision
  end
end
