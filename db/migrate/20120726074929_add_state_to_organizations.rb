class AddStateToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :state, :string
  end
end
