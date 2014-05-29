class AddIndexesOnCountryAndCities < ActiveRecord::Migration
  def change
    add_index :countries, :title_ru
    add_index :countries, :title_en
    add_index :countries, [:title_en, :title_ru]

    add_index :cities, :country_id
    add_index :cities, :title_ru
    add_index :cities, :title_en
    add_index :cities, [:title_en, :title_ru]
  end
end
