class AddAvailableToAbilities < ActiveRecord::Migration
  def change
    add_column :abilities, :available, :boolean, default: false
  end
end
