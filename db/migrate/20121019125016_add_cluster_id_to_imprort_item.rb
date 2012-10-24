class AddClusterIdToImprortItem < ActiveRecord::Migration
  def change
    add_column :import_items, :cluster_id, :integer
  end
end
