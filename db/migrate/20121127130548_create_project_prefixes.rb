class CreateProjectPrefixes < ActiveRecord::Migration
  def change
    create_table :project_prefixes do |t|
      t.string :name

      t.timestamps
    end
  end
end
