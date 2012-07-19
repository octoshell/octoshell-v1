class AddDeletedAtToAllModels < ActiveRecord::Migration
  def change
    %w(accesses clusters memberships position_names positions tasks).each do |table|
      add_column table.to_sym, :deleted_at, :timestamp 
    end
  end
end
