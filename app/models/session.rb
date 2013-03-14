class Session < ActiveRecord::Base
  belongs_to :personal_survey, class_name: :Survey
  belongs_to :projects_survey, class_name: :Survey
  belongs_to :counters_survey, class_name: :Survey
  
  validates :start_at, :end_at, presence: true
  validate :range_validator, if: proc { |s| s.start_at? && s.end_at? }, on: :create
  
  attr_accessible :start_at, :end_at, as: :admin
  
  before_create :create_surveys!
  
  state_machine :state, initial: :pending do
    state :pending
    state :active
    state :ended
    
    event :start do
      transition :pending => :active
    end
    
    event :end do
      transition :active => :ended
    end
    
    around_transition :on => :start do |session, transition, block|
      session.transaction do
        block.call
        session.create_surveys_for_users!
      end
    end
  end
  
  def create_surveys_for_users!
    create_surveys_for_managers!
    create_surveys_for_sured!
  end
  
private
  
  def create_surveys_for_managers!
    Project.with_state(:active).each do |project|
      project.user.user_surveys.scoped.tap do |user_surveys|
        user_surveys.create! { |us| us.survey = projects_survey }
        user_surveys.create! { |us| us.survey = counters_survey }
      end
    end
  end
  
  def create_surveys_for_sured!
    User.with_state(:sured).each do |user|
      user.user_surveys.create! do |us|
        us.survey = personal_survey
      end
    end
  end
  
  def range_validator
    sessions = Session.all.map do |session|
      session.start_at..session.end_at
    end
    block = proc { |d| sessions.any? { |range| range.include?(d) } }
    if (start_at..end_at).any?(&block) || (start_at > end_at)
      errors.add(:base, :date_is_out_of_available_range)
    end
  end
  
  def create_surveys!
    self.create_personal_survey!
    self.create_projects_survey!
    self.create_counters_survey!
    true
  end
end
