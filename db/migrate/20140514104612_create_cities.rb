class CreateCities < ActiveRecord::Migration
  def change
    create_table :_cities do |t|
      t.integer :country_id, null: false
      t.string :title_ru
      t.string :title_en
      t.boolean :important
      t.integer :region_id

      t.string :title_ru
      t.string :area_ru
      t.string :region_ru

      t.string :title_ua
      t.string :area_ua
      t.string :region_ua

      t.string :title_be
      t.string :area_be
      t.string :region_be

      t.string :title_en
      t.string :area_en
      t.string :region_en

      t.string :title_es
      t.string :area_es
      t.string :region_es

      t.string :title_pt
      t.string :area_pt
      t.string :region_pt

      t.string :title_de
      t.string :area_de
      t.string :region_de

      t.string :title_fr
      t.string :area_fr
      t.string :region_fr

      t.string :title_it
      t.string :area_it
      t.string :region_it

      t.string :title_pl
      t.string :area_pl
      t.string :region_pl

      t.string :title_ja
      t.string :area_ja
      t.string :region_ja

      t.string :title_lt
      t.string :area_lt
      t.string :region_lt

      t.string :title_lv
      t.string :area_lv
      t.string :region_lv

      t.string :title_cz
      t.string :area_cz
      t.string :region_cz
    end
  end
end
