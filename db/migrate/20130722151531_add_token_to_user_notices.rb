class AddTokenToUserNotices < ActiveRecord::Migration
  def change
    add_column :user_notices, :token, :string
  end
end
