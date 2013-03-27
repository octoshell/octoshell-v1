class CreateSubdivisions < ActiveRecord::Migration
  def change
    create_table :subdivisions do |t|
      t.integer :organization_id
      t.string :name
      t.string :short

      t.timestamps
    end
  end
end
