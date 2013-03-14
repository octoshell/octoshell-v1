class UserSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  
  validates :user, :survey, presence: true
end
