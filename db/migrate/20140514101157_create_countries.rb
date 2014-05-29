class CreateCountries < ActiveRecord::Migration
  def change
    create_table :_countries do |t|
      t.string :title_ru
      t.string :title_en

      t.string :title_ua
      t.string :title_be
      t.string :title_es
      t.string :title_pt
      t.string :title_de
      t.string :title_fr
      t.string :title_it
      t.string :title_pl
      t.string :title_ja
      t.string :title_lt
      t.string :title_lv
      t.string :title_cz
    end
  end
end
