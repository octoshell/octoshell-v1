class UserSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :project
  
  validates :user, :survey, presence: true
end
