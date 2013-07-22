class AddUrlToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :url, :text
  end
end
