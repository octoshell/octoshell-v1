class AddHostToClusters < ActiveRecord::Migration
  def change
    add_column :clusters, :host, :string
  end
end
