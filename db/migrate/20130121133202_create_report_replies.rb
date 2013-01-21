class CreateReportReplies < ActiveRecord::Migration
  def change
    create_table :report_replies do |t|
      t.integer :report_id
      t.text :message
      t.integer :user_id
    end

    add_index :report_replies, :report_id
    add_index :report_replies, :user_id
  end
end
