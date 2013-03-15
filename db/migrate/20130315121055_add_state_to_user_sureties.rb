class AddStateToUserSureties < ActiveRecord::Migration
  def change
    add_column :user_sureties, :state, :string
  end
end
