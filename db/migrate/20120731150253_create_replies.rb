class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :user
      t.references :ticket
      t.text :message
      t.timestamps
    end
  end
end
