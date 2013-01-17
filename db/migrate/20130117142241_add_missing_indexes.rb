class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :organizations, :organization_kind_id
    add_index :account_codes, :user_id
    add_index :additional_emails, :user_id
    add_index :surety_members, :account_code_id
    add_index :reports, :user_id
    add_index :import_items, :cluster_id
    add_index :tickets, :ticket_question_id
    add_index :projects, :project_prefix_id
    add_index :requests, :cluster_project_id
  end
end
