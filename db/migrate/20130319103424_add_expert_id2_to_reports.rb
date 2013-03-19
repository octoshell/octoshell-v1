class AddExpertId2ToReports < ActiveRecord::Migration
  def change
    add_column :reports, :expert_id, :integer
    add_index :reports, :expert_id
  end
end
