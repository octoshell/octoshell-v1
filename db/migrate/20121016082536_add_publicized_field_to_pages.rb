class AddPublicizedFieldToPages < ActiveRecord::Migration
  def change
    add_column :pages, :publicized, :boolean, default: false
  end
end
