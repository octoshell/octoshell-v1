require 'csv'

# Строка данных для импорта
class ImportItem < ActiveRecord::Base
  CSV_ATTRIBUTES = [ :fio, :email, :organization_name, :project_name, :group,
    :login, :phone, :jsoned_directions, :jsoned_technologies, :jsoned_areas,
    :jsoned_keys ]
  
  belongs_to :cluster
  
  validates :first_name, :last_name, :middle_name, :email, :organization_name,
    :project_name, :group, :login, :keys, presence: true
  
  attr_accessor :additional_email

  attr_accessible :file, :first_name, :middle_name, :last_name,
    :organization_name, :project_name, :group, :login, :email, :additional_email,
    as: :admin
  serialize :keys
  serialize :directions
  serialize :technologies
  serialize :areas

  def self.create_by_file_and_cluster(attributes)
    cluster = Cluster.find(attributes[:cluster_id])
    transaction do
      attributes[:file].read.each_line do |line|
        data = line.parse_csv(col_sep: ";", quote_char: "'")
        
        create! do |item|
          CSV_ATTRIBUTES.each_with_index do |attribute, index|
            item.send "#{attribute}=", data[index].strip
          end
          item.cluster = cluster
        end
      end
    end
  end
  
  def import(attributes, role)
    if update_attributes(attributes, role)
      transaction do
        @user          = create_user!
        @org           = create_organization!
        @membership    = create_membership!
        @project       = create_project!
        @surety        = create_surety!
        @surety_member = create_surety_member!
        @account       = create_account!
        @keys          = create_credentials!
        @request       = create_request!
        destroy
      end
      if @new_user
        Mailer.welcome_imported_user(@user.id).deliver
      end
      true
    end
  end

  def fio=(fio)
    last, first, middle = fio.split(' ')
    if middle.blank?
      middle = '-'
    end
    self.first_name = first
    self.middle_name = middle
    self.last_name = last
  end

  def email=(email)
    self[:email] = email.downcase.strip 
  end
  
  def jsoned_keys=(json)
    self.keys = JSON.parse(json).map(&:strip).uniq
  end

  def jsoned_directions=(json)
    self.directions = JSON.parse(json).map(&:strip).uniq
  end

  def jsoned_technologies=(json)
    self.technologies = JSON.parse(json).map(&:strip).uniq
  end
  
  def jsoned_areas=(json)
    self.areas = JSON.parse(json).map(&:strip).uniq
  end
  
  def user_in_json(options)
    User.new do |u|
      u.first_name = first_name
      u.middle_name = middle_name
      u.last_name = last_name
      u.email = email
    end.to_json(options)
  end
  
  def similar_users
    users = []
    users.push *User.where("last_name = :name or first_name = :name or middle_name = :name", name: last_name)
    users.push *User.where("email like ?", "%#{email[/^(.*)@/, 1]}%@%")
    users.uniq!
    users
  end
  
  def similar_organizations
    Organization.find_similar(organization_name)
  end
  
  def organization_in_json(options)
    Organization.new do |org|
      org.name = organization_name
    end.to_json(options)
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
        user.phone            = phone
        user.reset_password_token = SecureRandom.hex(16)
        user.reset_password_email_sent_at = Time.now.in_time_zone
        user.reset_password_token_expires_at = Time.now.in_time_zone + 1.year
      end
      @new_user = true
      User.find(u.id)
    end
    user.valid? or raise user.errors.inspect # ActiveRecord::RecordInvalid.new(user)
    user.tap do |user|
      user.first_name       = first_name
      user.middle_name      = middle_name
      user.last_name        = last_name
      if additional_email.present?
        user.additional_emails.build { |e| e.email = additional_email }
      end
    end.save!
    user.send :setup_default_groups
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
      surety.organization_id = @org.id
      surety.boss_full_name = "Руководитель. И. О."
      surety.boss_position = "Должность"
      surety.project_id = @project.id
      surety.state = 'active'
    end
    surety = Surety.find(s.id)
    surety.valid? or raise surety.errors.inspect
    surety
  end

  def create_surety_member!
    s = SuretyMember.to_generic_model.create! do |member|
      member.surety_id = @surety.id
      member.email = email
      member.full_name = @user.full_name
      member.user_id = @user.id
    end
    sm = SuretyMember.find(s.id)
    sm.valid? or raise sm.errors.inspect
    sm
  end
  
  def create_project!
    project = @user.projects.find_by_title(project_name) || begin
      p = Project.to_generic_model.create! do |project|
        project.user_id = @user.id
        project.title = project_name
        project.description = project_name
        project.state = 'active'
        project.organization_id = @org.id
        project.username = group
      end
      project = Project.find(p.id)
      project.direction_of_sciences = directions.map { |d| DirectionOfScience.find_or_create_by_name!(d) }
      project.critical_technologies = technologies.map { |t| CriticalTechnology.find_or_create_by_name!(t) }
      project.research_areas = areas.map do |a|
        ResearchArea.find_or_create_by_name!(a) do |ra|
          ra.group = "Без группы"
        end
      end
      project
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
        account.access_state = 'allowed'
        account.cluster_state = 'active'
        account.username = login
      end
      a = Account.find(a.id)
    end
    account.valid? or raise account.errors.inspect
    account
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
  
  def create_request!
    @request = begin
      r = Request.to_generic_model.create! do |r|
        r.state = 'active'
        r.user_id = @user.id
        r.cluster_project_id = @group.id
        r.cpu_hours = 0
        r.gpu_hours = 0
        r.size      = 0
      end
      Request.find(r.id)
    end
  end
end
