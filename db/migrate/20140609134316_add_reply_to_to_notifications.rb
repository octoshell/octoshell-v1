class AddReplyToToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :reply_to, :string
  end
end
