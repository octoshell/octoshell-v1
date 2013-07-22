class AddDeliveredToUserNotices < ActiveRecord::Migration
  def change
    add_column :user_notices, :deliver_state, :string
  end
end
