class AddCityAndCountryToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :country_id, :integer
    add_column :organizations, :city_id, :integer
  end
end
