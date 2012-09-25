class AddLocatorToPages < ActiveRecord::Migration
  def change
    add_column :pages, :locator, :text
  end
end
