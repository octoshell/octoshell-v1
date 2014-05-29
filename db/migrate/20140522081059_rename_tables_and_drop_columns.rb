class RenameTablesAndDropColumns < ActiveRecord::Migration
  def change
    rename_table :_countries, :countries
    rename_table :_cities, :cities

    remove_column :countries, :title_ua
    remove_column :countries, :title_be
    remove_column :countries, :title_es
    remove_column :countries, :title_pt
    remove_column :countries, :title_de
    remove_column :countries, :title_fr
    remove_column :countries, :title_it
    remove_column :countries, :title_pl
    remove_column :countries, :title_ja
    remove_column :countries, :title_lt
    remove_column :countries, :title_lv
    remove_column :countries, :title_cz

    remove_column :cities, :region_id

    remove_column :cities, :area_ru
    remove_column :cities, :region_ru

    remove_column :cities, :title_ua
    remove_column :cities, :area_ua
    remove_column :cities, :region_ua

    remove_column :cities, :title_be
    remove_column :cities, :area_be
    remove_column :cities, :region_be

    remove_column :cities, :area_en
    remove_column :cities, :region_en

    remove_column :cities, :title_es
    remove_column :cities, :area_es
    remove_column :cities, :region_es

    remove_column :cities, :title_pt
    remove_column :cities, :area_pt
    remove_column :cities, :region_pt

    remove_column :cities, :title_de
    remove_column :cities, :area_de
    remove_column :cities, :region_de

    remove_column :cities, :title_fr
    remove_column :cities, :area_fr
    remove_column :cities, :region_fr

    remove_column :cities, :title_it
    remove_column :cities, :area_it
    remove_column :cities, :region_it

    remove_column :cities, :title_pl
    remove_column :cities, :area_pl
    remove_column :cities, :region_pl

    remove_column :cities, :title_ja
    remove_column :cities, :area_ja
    remove_column :cities, :region_ja

    remove_column :cities, :title_lt
    remove_column :cities, :area_lt
    remove_column :cities, :region_lt

    remove_column :cities, :title_lv
    remove_column :cities, :area_lv
    remove_column :cities, :region_lv

    remove_column :cities, :title_cz
    remove_column :cities, :area_cz
    remove_column :cities, :region_cz
  end
end
