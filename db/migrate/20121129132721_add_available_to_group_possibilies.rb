class AddAvailableToGroupPossibilies < ActiveRecord::Migration
  def change
    add_column :group_abilities, :available, :boolean
  end
end
