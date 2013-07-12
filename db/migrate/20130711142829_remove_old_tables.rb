class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :accesses
    remove_column :accounts, :state
    drop_table :cluster_projects
    drop_table :cluster_users
    drop_table :expands
    drop_table :fields
    drop_table :values
    drop_table :group_abilities
    drop_table :old_report_comments
    drop_table :old_report_organizations
    drop_table :old_report_personal_data
    drop_table :old_report_personal_surveys
    drop_table :old_report_projects
    drop_table :old_report_replies
    drop_table :old_reports
    drop_table :tasks
    remove_column :tickets, :report_id
    remove_column :users, :admin
    remove_column :requests, :cluster_project_id
  end
end
