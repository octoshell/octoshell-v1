class RemoveUnnessessaryClusterFields < ActiveRecord::Migration
  def change
    remove_column :clusters, :add_user, :del_user, :add_openkey,
      :del_openkey, :block_user, :unblock_user, :get_statistic
  end
end
