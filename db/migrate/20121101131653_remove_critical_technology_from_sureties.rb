class RemoveCriticalTechnologyFromSureties < ActiveRecord::Migration
  def up
    remove_column :sureties, :critical_technology_id
  end

  def down
    add_column :sureties, :critical_technology_id, :integer
  end
end
