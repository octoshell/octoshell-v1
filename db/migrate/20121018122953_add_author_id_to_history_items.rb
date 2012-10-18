class AddAuthorIdToHistoryItems < ActiveRecord::Migration
  def change
    add_column :history_items, :author_id, :integer
  end
end
