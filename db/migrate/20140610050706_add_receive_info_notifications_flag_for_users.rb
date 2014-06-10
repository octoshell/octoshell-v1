class AddReceiveInfoNotificationsFlagForUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_info_notifications, :boolean, default: true
  end
end
