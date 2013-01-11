class CreatePossibilities < ActiveRecord::Migration
  def change
    create_table :abilities do |t|
      t.string :action
      t.string :subject
      t.timestamps
    end
  end
end
