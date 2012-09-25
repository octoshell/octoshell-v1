class DestroyWikiUrls < ActiveRecord::Migration
  def change
    drop_table :wiki_urls
  end
end
