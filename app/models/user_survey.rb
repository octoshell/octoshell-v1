class UserSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :project
  
  validates :user, :survey, presence: true
  
  state_machine :state, initial: :start do
    state :pending
    state :filling
    state :submitted
    
    event :accept do
      transition pending: :filling
    end
    
    event :submit do
      transition filling: :submitted
    end
  end
end
