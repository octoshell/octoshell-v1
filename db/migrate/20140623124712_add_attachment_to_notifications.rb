class AddAttachmentToNotifications < ActiveRecord::Migration
  def change
    add_attachment :notifications, :attachment
  end
end
