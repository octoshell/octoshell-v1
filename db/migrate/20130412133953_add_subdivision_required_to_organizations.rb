class AddSubdivisionRequiredToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :subdivision_required, :boolean, default: false
  end
end
