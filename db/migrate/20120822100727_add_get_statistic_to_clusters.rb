class AddGetStatisticToClusters < ActiveRecord::Migration
  def change
    add_column :clusters, :get_statistic, :text, default: "host=%host%"
  end
end
