class AddSubdivisionToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :subdivision, :string
  end
end
