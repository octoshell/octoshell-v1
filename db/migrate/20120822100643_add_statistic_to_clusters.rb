class AddStatisticToClusters < ActiveRecord::Migration
  def change
    add_column :clusters, :statistic, :text
  end
end
