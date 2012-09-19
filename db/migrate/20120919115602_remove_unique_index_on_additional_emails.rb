class RemoveUniqueIndexOnAdditionalEmails < ActiveRecord::Migration
  def change
    remove_index :additional_emails, :email
  end
end
