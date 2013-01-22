class CreateReportComments < ActiveRecord::Migration
  def change
    create_table :report_comments do |t|
      t.text :message
      t.integer :user_id
      t.integer :report_id
    end

    add_index :report_comments, :user_id
    add_index :report_comments, :report_id
  end
end
