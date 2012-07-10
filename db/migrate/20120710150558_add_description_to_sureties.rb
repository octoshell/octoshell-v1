class AddDescriptionToSureties < ActiveRecord::Migration
  def change
    add_column :sureties, :description, :text
  end
end
