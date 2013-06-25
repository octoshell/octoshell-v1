class SetDefaultGroupByInStats < ActiveRecord::Migration
  def change
    change_column_default :stats, :group_by, "count"
  end
end
