class AddSizeToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :size, :integer
  end
end
