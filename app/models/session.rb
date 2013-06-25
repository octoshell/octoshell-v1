class Session < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :personal_survey, class_name: :Survey
  belongs_to :projects_survey, class_name: :Survey
  belongs_to :counters_survey, class_name: :Survey
  has_many :reports
  has_many :stats
  
  validates :description, :receiving_to, presence: true
  
  attr_accessible :description, :motivation, :receiving_to, as: :admin
  
  before_create :create_surveys!
  
  state_machine :state, initial: :pending do
    state :pending
    state :active do
      validate do
        if Session.with_state(:active).exists?
          errors.add(:base, :date_is_out_of_available_range)
        end
      end
    end
    state :ended
    
    event :start do
      transition :pending => :active
    end
    
    event :stop do
      transition :active => :ended
    end
    
    inside_transition :on => :start do |session|
      session.create_surveys_for_users!
      session.touch :started_at
    end
    
    inside_transition :on => :stop do |session|
      session.touch :ended_at
      User.delay.find_each &:examine!
    end
  end
  
  def users
    users = user_surveys.select(:user_id).uniq.to_sql
    reports = Report.joins(:project).select("projects.user_id").
      where(session_id: id).uniq.to_sql
      
    User.where %(id in ((#{users}) UNION (#{reports})))
  end
  
  def self.current
    with_state(:active).first
  end
  
  def user_surveys
    UserSurvey.where(survey_id: survey_ids)
  end
  
  def organizations_count_by_kind
    project_ids = reports.pluck(:project_id)
    organization_ids = Project.where(id: project_ids).pluck(:organization_id).uniq
    Organization.where(id: organization_ids).group(:organization_kind_id).count.map do |id, count|
      [OrganizationKind.find(id).name, count]
    end.sort_by(&:first)
  end
  
  def projects_count_by_kind
    project_ids = reports.pluck(:project_id)
    includes = { organization: :organization_kind }
    Project.where(id: project_ids).includes(includes).group_by do |p|
      p.organization.organization_kind.name
    end.map do |kind, projects|
      [kind, projects.size]
    end.sort_by(&:first)
  end
  
  def projects_count_by_msu_subdivisions
    msu = Organization.find(497)
    Project.find(reports.pluck(:project_id)).group_by do |p|
      if m = p.user.memberships.where(organization_id: p.organization_id).first
        m.subdivision.try(:graph_name)
      end
    end.find_all { |p| p[0].present? } .map do |name, projects|
      [name, projects.size]
    end.sort_by(&:first)
  end
  
  def users_by_organization_kind
    project_ids = reports.pluck(:project_id)
    user_ids = Account.with_cluster_state(:active).with_access_state(:allowed).where(project_id: project_ids).pluck(:user_id)
    Membership.where(user_id: user_ids).group_by do |member|
      member.organization.organization_kind.name
    end.map do |name, array|
      [name, array.size]
    end.sort_by(&:first)
  end
  
  def users_by_msu_subdivisions
    project_ids = reports.pluck(:project_id)
    user_ids = Account.with_cluster_state(:active).with_access_state(:allowed).where(project_id: project_ids).pluck(:user_id)
    Membership.where("subdivision_id is not null").where(user_id: user_ids, organization_id: 497).group_by do |member|
      member.subdivision.name
    end.map do |name, array|
      [name, array.size]
    end.sort_by(&:first)
  end
  
  def direction_of_science_by_count
    project_ids = reports.pluck(:project_id)
    stack = []
    Project.find(project_ids).each do |p|
      p.direction_of_sciences.map do |d|
        stack << d.name
      end
    end
    stack.group_by do |e|
      e
    end.map do |name, array|
      [name, array.size]
    end.sort_by(&:first)
  end
  
  def direction_of_sciences_by_msu_subdivisions
    msu = Organization.find(497)
    projects = msu.projects.where(id: reports.pluck(:project_id)).includes(:direction_of_sciences)
    memberships = Membership.joins(user: { owned_projects: :direction_of_sciences }).
      where(subdivision_id: Subdivision.where(organization_id: 497).pluck(:id)).
      select("\"memberships\".*, direction_of_sciences_projects.direction_of_science_id").
      includes(:subdivision)
    directions = DirectionOfScience.order("name").to_a
    rows = []
    rows << ["Subdivision", directions.map(&:name)].flatten
    memberships.group_by do |member|
      direction = directions.find { |d| d.id == member.direction_of_science_id.to_i }
      [direction.name, member.subdivision.graph_name]
    end.each do |group, array|
      row = [group[1]]
      directions.each do |direction|
        row << (group[0] == direction.name ? array.size : 0)
      end
      rows << row
    end
    rows
  end
  
  def survey_fields
    Survey::Field.where(survey_id: survey_ids)
  end
  
  def survey_ids
    [ personal_survey_id,
      projects_survey_id,
      counters_survey_id ]
  end
  
  def create_surveys_for_users!
    create_surveys_for_managers!
    create_reports_for_managers!
    create_surveys_for_sured!
  end
  
  def not_sent?
    pending? || filling?
  end
  
private
  
  def create_surveys_for_managers!
    Project.with_state(:active).each do |project|
      [ proc { |us| us.survey = projects_survey; us.project = project },
        proc { |us| us.survey = counters_survey; us.project = project }
      ].each { |b| project.user.user_surveys.create!(&b) }
    end
  end
  
  def create_reports_for_managers!
    Project.with_state(:active).each do |project|
      reports.create! { |r| r.project = project }
    end
  end
  
  def create_surveys_for_sured!
    User.with_state(:sured).each do |user|
      user.user_surveys.create! do |us|
        us.survey = personal_survey
      end
    end
  end
  
  def create_surveys!
    self.create_personal_survey!
    self.create_projects_survey!
    self.create_counters_survey!
    true
  end
end
