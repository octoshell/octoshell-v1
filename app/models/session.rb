# Перерегистрация
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
  
  def survey_fields
    Survey::Field.where(survey_id: survey_ids)
  end
  
  def survey_ids
    [ personal_survey_id,
      projects_survey_id,
      counters_survey_id ]
  end
  
  def create_surveys_for_users!
    delay.create_surveys_for_managers!
    delay.create_reports_for_managers!
    delay.create_surveys_for_sured!
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
