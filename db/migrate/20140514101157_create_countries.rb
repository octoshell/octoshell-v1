class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :title
    end
  end
end
