class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :country_id, null: false
      t.string :title
    end
  end
end
