class FirstCleanup < ActiveRecord::Migration
  def up
    # accesses
    remove_index :accesses, name: 'unique_active'
    remove_column :accesses, :deleted_at
    add_index :accesses, :credential_id
    add_index :accesses, :state
    
    # accounts
    remove_column :accounts, :deleted_at
    add_index :accounts, :state
    
    # cluster users
    add_index :cluster_users, :project_id
    add_index :cluster_users, :cluster_id
    
    # clusters
    remove_column :clusters, :deleted_at
    add_index :clusters, :state
    
    # credentials
    remove_column :credentials, :deleted_at
    add_index :credentials, :user_id
    add_index :credentials, [:user_id, :state]
    
    # memberships
    remove_column :memberships, :deleted_at
    add_index :memberships, :user_id
    add_index :memberships, :organization_id
    
    # organization kinds
    add_index :organization_kinds, :state
    
    # organizations
    remove_column :organizations, :deleted_at
    add_index :organizations, :organization_kind_id
    add_index :organizations, :state
    
    # position names
    remove_column :position_names, :deleted_at
    
    # positions
    remove_column :positions, :deleted_at
    add_index :positions, :membership_id
    
    # projects
    remove_column :projects, :deleted_at
    add_index :projects, :user_id
    add_index :projects, :state
    add_index :projects, :organization_id
    
    # replies
    add_index :replies, :user_id
    add_index :replies, :ticket_id
    
    # requests
    remove_column :requests, :deleted_at
    add_index :requests, :user_id
    add_index :requests, :state
    
    # sureties
    remove_column :sureties, :deleted_at
    add_index :sureties, :user_id
    add_index :sureties, :organization_id
    add_index :sureties, :state
    
    # tasks
    remove_column :tasks, :deleted_at
    add_index :tasks, :state
    add_index :tasks, [:resource_id, :resource_type]
    
    # ticket field relations
    add_index :ticket_field_relations, :ticket_question_id
    add_index :ticket_field_relations, :ticket_field_id
    
    # ticket field values
    add_index :ticket_field_values, :ticket_field_relation_id
    add_index :ticket_field_values, :ticket_id
    
    # ticket fields
    add_index :ticket_fields, :state
    
    # ticket questions
    add_index :ticket_questions, :ticket_question_id
    add_index :ticket_questions, :state
    
    # ticket tag relations
    add_index :ticket_tag_relations, :ticket_id
    add_index :ticket_tag_relations, :ticket_tag_id
    
    # ticket tags
    add_index :ticket_tags, :state
    
    # ticket templates
    add_index :ticket_templates, :state
    
    # tickets
    add_index :tickets, :user_id
    add_index :tickets, :project_id
    add_index :tickets, :cluster_id
    add_index :tickets, :state
    
    # users
    add_index :users, :state
  end

  def down
  end
end
