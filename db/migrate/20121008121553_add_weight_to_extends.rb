class AddWeightToExtends < ActiveRecord::Migration
  def change
    add_column :extends, :weight, :integer, default: 1
  end
end
