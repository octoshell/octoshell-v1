class AddDefaultToRequestsSize < ActiveRecord::Migration
  def change
    change_column_default :requests, :size, 0
  end
end
