class RemoveDescriptionFromSureties < ActiveRecord::Migration
  def up
    remove_column :sureties, :description
  end

  def down
    add_column :sureties, :description, :string
  end
end
