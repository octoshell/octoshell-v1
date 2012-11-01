class AddBossPositionToSureties < ActiveRecord::Migration
  def change
    add_column :sureties, :boss_position, :string
  end
end
