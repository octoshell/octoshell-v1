class AddRequestDataToSureties < ActiveRecord::Migration
  def change
    add_column :sureties, :cpu_hours, :integer, default: 0
    add_column :sureties, :size, :integer, default: 0
    add_column :sureties, :gpu_hours, :integer, default: 0
  end
end
