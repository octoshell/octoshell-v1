class CreateResearchAreas < ActiveRecord::Migration
  def change
    create_table :research_areas do |t|
      t.string :group
      t.string :name
      t.integer :weight, default: 0
    end
  end
end
