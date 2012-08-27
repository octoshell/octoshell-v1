class AddClusterUserTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cluster_user_type, :string, default: 'account'
  end
end
