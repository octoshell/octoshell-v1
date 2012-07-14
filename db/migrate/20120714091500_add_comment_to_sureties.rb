class AddCommentToSureties < ActiveRecord::Migration
  def change
    add_column :sureties, :comment, :string
  end
end
