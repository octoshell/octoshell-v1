class AddClusterUserTypeToClusters < ActiveRecord::Migration
  def change
    add_column :clusters, :cluster_user_type, :string, default: 'account'
  end
end
