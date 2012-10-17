class AddAutocompleteToPositionNames < ActiveRecord::Migration
  def change
    add_column :position_names, :autocomplete, :text
  end
end
