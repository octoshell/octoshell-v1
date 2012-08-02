class AddAttachmentAttachmentToReplies < ActiveRecord::Migration
  def self.up
    change_table :replies do |t|
      t.has_attached_file :attachment
    end
  end

  def self.down
    drop_attached_file :replies, :attachment
  end
end
