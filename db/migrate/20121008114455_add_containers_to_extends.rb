class AddContainersToExtends < ActiveRecord::Migration
  def change
    add_column :extends, :header, :string
    add_column :extends, :footer, :string
  end
end
