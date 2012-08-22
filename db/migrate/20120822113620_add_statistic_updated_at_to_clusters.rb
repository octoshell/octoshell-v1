class AddStatisticUpdatedAtToClusters < ActiveRecord::Migration
  def change
    add_column :clusters, :statistic_updated_at, :datetime
  end
end
