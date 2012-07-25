class AddStateToClusters < ActiveRecord::Migration
  def change
    add_column :clusters, :state, :string
  end
end
