require 'csv'
class ImportItem < ActiveRecord::Base
  belongs_to :cluster
  
  validates :first_name, :last_name, :middle_name, :email, :organization_name,
    :project_name, :group, :login, :keys, presence: true
  
  attr_accessible :file, :first_name, :middle_name, :last_name,
    :organization_name, :project_name, :group, :login, :email, as: :admin
  serialize :keys
  
  def import(attributes, role)
    if update_attributes(attributes, role)
      transaction do
        @user       = create_user!
        @org        = create_organization!
        @membership = create_membership!
        @surety     = create_surety!
        @project    = create_project!
        @account    = create_account!
        @group      = create_cluster_project!
        @login      = create_cluster_user!
        @keys       = create_credentials!
        @accesses   = create_accesses!
        destroy
      end
      true
    end
  end
  
  def user_in_json(options)
    User.new do |u|
      u.first_name = first_name
      u.middle_name = middle_name
      u.last_name = last_name
      u.email = email
    end.to_json(options)
  end
  
  def simular_users
    users = []
    users.push *User.where(last_name: last_name)
    users.push *User.where("email like ?", "%#{email[/^(.*)@/, 1]}%@%")
    users.uniq
  end
  
  def simular_organizations
    Organization.find_similar(organization_name)
  end
  
  def organization_in_json(options)
    Organization.new do |org|
      org.name = organization_name
    end.to_json(options)
  end
  
  def self.create_by_file_and_cluster(attributes)
    file, cluster_id = attributes[:file], attributes[:cluster_id]
    return false if file.blank? or cluster_id.blank?
    
    transaction do
      file.read.each_line do |line|
        data = line.parse_csv(col_sep: ";", quote_char: "'")
        data[6] = JSON.parse(data[6])
        first, middle, last = data[0].split(' ')
        if last.blank?
          last = middle
          middle = '-'
        end
        create! do |item|
          item.cluster_id        = cluster_id
          item.first_name        = first
          item.middle_name       = middle
          item.last_name         = last
          item.email             = data[1]
          item.organization_name = data[2]
          item.project_name      = data[3]
          item.group             = data[4]
          item.login             = data[5]
          item.keys              = data[6]
        end
      end
    end
  end
  
private
  
  def create_user!
    user = User.find_by_email(email) || begin
      u = User.to_generic_model.create! do |user|
        user.first_name       = first_name
        user.middle_name      = middle_name
        user.last_name        = last_name
        user.email            = email
        user.state            = 'sured'
        user.activation_state = 'active'
        user.token            = Digest::SHA1.hexdigest(rand.to_s)
        user.phone            = '-'
      end
      User.find(u.id)
    end
    user.valid? or raise user.errors.inspect # ActiveRecord::RecordInvalid.new(user)
    user
  end
  
  def create_organization!
    organization = Organization.find_by_name(organization_name) || begin
      o = Organization.to_generic_model.create! do |org|
        org.name = organization_name
        org.state = 'active'
        org.organization_kind_id = OrganizationKind.first.id
      end
      o = Organization.find(o.id)
    end
    organization.valid? or raise organization.errors.inspect
    organization
  end
  
  def create_membership!
    conditions = { organization_id: @org.id, user_id: @user.id }
    membership = Membership.where(conditions).first || begin
      m = Membership.to_generic_model.create! do |membership|
        membership.user_id = @user.id
        membership.organization_id = @org.id
        membership.state = 'active'
      end
    end
    membership.valid? or raise organization.errors.inspect
    membership
  end
  
  def create_surety!
    s = Surety.to_generic_model.create! do |surety|
      surety.user_id = @user.id
      surety.organization_id = @org.id
      surety.state = 'active'
    end
    surety = Surety.find(s.id)
    surety.valid? or raise surety.errors.inspect
    surety
  end
  
  def create_project!
    project = @user.projects.find_by_name(project_name) || begin
      p = Project.to_generic_model.create! do |project|
        project.user_id = @user.id
        project.name = project_name
        project.description = project_name
        project.state = 'active'
        project.organization_id = @org.id
        project.username = group
      end
      Project.find(p.id)
    end
    project.valid? or raise project.errors.inspect
    project
  end
  
  def create_account!
    conditions = { user_id: @user.id, project_id: @project.id }
    account = Account.where(conditions).first || begin
      a = Account.to_generic_model.create! do |account|
        account.user_id = @user.id
        account.project_id = @project.id
        account.state = 'active'
        account.username = login
      end
      a = Account.find(a.id)
    end
    account.valid? or raise account.errors.inspect
    account
  end
  
  def create_cluster_project!
    conditions = { cluster_id: cluster_id, project_id: @project.id }
    cluster_project = ClusterProject.where(conditions).first || begin
      cp = ClusterProject.to_generic_model.create! do |cp|
        cp.cluster_id = cluster_id
        cp.project_id = @project.id
        cp.state = 'active'
        cp.username = group
      end
      ClusterProject.find(cp.id)
    end
    cluster_project.valid? or raise cluster_project.errors.inspect
    cluster_project
  end
  
  def create_cluster_user!
    conditions = { cluster_project_id: @group.id, account_id: @account.id }
    cluster_user = ClusterUser.where(conditions).first || begin
      cu = ClusterUser.to_generic_model.create! do |cu|
        cu.cluster_project_id = @group.id
        cu.account_id = @account.id
        cu.username = login
        cu.state = 'active'
      end
      ClusterUser.find(cu.id)
    end
    cluster_user.valid? or raise cluster_user.errors.inspect
    cluster_user
  end
  
  def create_credentials!
    keys.map do |key|
      key = @user.credentials.where(public_key: key).first || begin
        c = Credential.to_generic_model.create! do |c|
          c.name = key[0..6]
          c.state = 'active'
          c.user_id = @user.id
          c.public_key = key
        end
        Credential.find(c.id)
      end
      
      key.valid? or raise key.errors.inspect
      key
    end
  end
  
  def create_accesses!
    @keys.map do |key|
      access = @login.accesses.where(credential_id: key.id).first || begin
        a = Access.to_generic_model.create! do |a|
          a.cluster_user_id = @login.id
          a.credential_id = key.id
          a.state = 'active'
        end
        Access.find(a.id)
      end
      access.valid? or raise access.errors.inspect
      access
    end
  end
end
