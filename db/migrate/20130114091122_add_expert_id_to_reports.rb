class AddExpertIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :expert_id, :integer
  end
end
