class AddSuperviserCommentToReports < ActiveRecord::Migration
  def change
    add_column :reports, :superviser_comment, :text
  end
end
