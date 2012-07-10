class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.references :user
      t.references :organization
      t.string :state
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
