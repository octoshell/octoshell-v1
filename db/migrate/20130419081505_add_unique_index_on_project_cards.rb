class AddUniqueIndexOnProjectCards < ActiveRecord::Migration
  def change
    remove_index :project_cards, :project_id
    add_index :project_cards, :project_id, unique: true
  end
end
