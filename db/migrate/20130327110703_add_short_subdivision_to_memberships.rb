class AddShortSubdivisionToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :short_subdivision, :string
  end
end
