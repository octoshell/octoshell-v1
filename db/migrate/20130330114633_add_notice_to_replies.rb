class AddNoticeToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :notice, :text
  end
end
