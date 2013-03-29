class AddCacheToStats < ActiveRecord::Migration
  def change
    add_column :stats, :cache, :text
  end
end
