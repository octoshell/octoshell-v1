class AddAbbreviationToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :abbreviation, :string
  end
end
