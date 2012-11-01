class AddBossFullNameToSureties < ActiveRecord::Migration
  def change
    add_column :sureties, :boss_full_name, :string
  end
end
