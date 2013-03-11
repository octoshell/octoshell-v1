class Session < ActiveRecord::Base
  belongs_to :personal_survey, class_name: :Survey
  belongs_to :projects_survey, class_name: :Survey
  belongs_to :counters_survey, class_name: :Survey
  
  validates :start_at, :end_at, presence: true
  validate :range_validator, if: proc { |s| s.start_at? && s.end_at? }
  
  attr_accessible :start_at, :end_at, as: :admin
  
  after_create :create_surveys!
  
private
  
  def range_validator
    sessions = Session.all.map do |session|
      session.start_at..session.end_at
    end
    block = proc { |d| sessions.any? { |range| range.include?(d) } }
    if (start_at..end_at).any?(&block)
      errors.add(:base, :date_is_out_of_available_range)
    end
    if start_at > end_at
      errors.add(:base, :date_is_out_of_available_range)
    end
  end
  
  def create_surveys!
    create_personal_survey!
    create_projects_survey!
    create_counters_survey!
  end
end
