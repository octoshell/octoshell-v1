require 'csv'

class Importer
  attr_reader :name, :email, :organization, :project, :group, :user,
    :cluster_id, :pub_keys, :organization_name, :project_name, :account,
    :cluster_project, :cluster_user, :credentials, :accesses, :login
  
  def initialize(name, email, organization, project, group, login, cluster_id, pub_keys)
    @name = name
    @email = email
    @organization_name = organization
    @project_name = project
    @group = group
    @login = login
    @cluster_id = cluster_id
    @pub_keys = pub_keys
  end
  
  def self.import(csv_string)
    ActiveRecord::Base.transaction do
      csv_string.each_line do |line|
        args = line.parse_csv(col_sep: ";", quote_char: "'")
        args << JSON.parse(args.pop)
        new(*args).run
      end
    end
  end
  
  def run
    %w(user organization membership surety project account cluster_project 
      cluster_user credentials accesses).each do |entity|
      
      send "create_#{entity}"
    end
  end
  
private
  
  def create_user
    return if @user = User.find_by_email(email)
    
    @user = User.to_generic_model.create! do |user|
      user.first_name, user.last_name = name.split(' ')
      user.email = email
      user.state = 'sured'
    end
  end
  
  def create_organization
    return if @organization = Organization.find_by_name(organization)
    
    @organization = Organization.to_generic_model.create! do |org|
      org.name = organization_name
      org.state = 'active'
    end
  end
  
  def create_membership
    @membership = Membership.to_generic_model.create! do |mem|
      mem.organization_id = organization.id
      mem.user_id = user.id
      mem.state = 'active'
    end
  end
  
  def create_surety
    @surety = Surety.to_generic_model.create! do |surety|
      surety.user_id = user.id
      surety.state = 'active'
    end
  end
  
  def create_project
    return if @project = Project.find_by_name(project_name)
    
    @project = Project.to_generic_model.create! do |project|
      project.name = project_name
      project.state = 'active'
      project.organization_id = organization.id
      project.username = group
    end
  end
  
  def create_account
    return if @account = Account.where(project_id: project.id, user_id: user.id).first
    
    @account = Account.to_generic_model.create! do |account|
      account.project_id = project.id
      account.user_id = user.id
      account.state = 'active'
    end
  end
  
  def create_cluster_project
    return if @cluster_project = ClusterProject.where(project_id: project.id, cluster_id: cluster_id).first
    
    @cluster_project = ClusterProject.to_generic_model.create! do |cluster_project|
      cluster_project.project_id = project.id
      cluster_project.username = group
      cluster_project.cluster_id = cluster_id
      cluster_project.state = 'active'
    end
  end
  
  def create_cluster_user
    return if @cluster_user = ClusterUser.where(cluster_project_id: cluster_project.id, account_id: account.id).first
    
    @cluster_user = ClusterUser.to_generic_model.create! do |cluster_user|
      cluster_user.cluster_project_id = cluster_project.id
      cluster_user.username = login
      cluster_user.account_id = account.id
      cluster_user.state = 'active'
    end
  end
  
  def create_credentials
    
  end
  
  def create_accesses
    
  end
end
