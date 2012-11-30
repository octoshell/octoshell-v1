class AddGroupIdToAbilities < ActiveRecord::Migration
  def change
    add_column :abilities, :group_id, :integer

    add_index :abilities, :group_id
    add_index :abilities, [:group_id, :subject, :action], unique: true
  end
end
