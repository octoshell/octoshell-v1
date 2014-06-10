class AddIsInfoToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :is_information, :boolean
  end
end
