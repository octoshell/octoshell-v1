class CreateGroupPossibilities < ActiveRecord::Migration
  def change
    create_table :group_abilities do |t|
      t.integer :group_id
      t.integer :ability_id
    end

    add_index :group_abilities, :group_id
    add_index :group_abilities, :ability_id
    add_index :group_abilities, [:group_id, :ability_id], unique: true
  end
end
