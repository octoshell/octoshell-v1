class CreateWikiUrls < ActiveRecord::Migration
  def change
    create_table :wiki_urls do |t|
      t.integer :page_id
      t.string :url
    end
    
    add_index :wiki_urls, :url
    add_index :wiki_urls, :page_id
  end
end
