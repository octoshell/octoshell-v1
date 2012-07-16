class Account < ActiveRecord::Base
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  
  validates :user, :project, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :canceled
    
    event :_activate do
      transition pending: :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_canceled do
      transition active: :canceled
    end
  end
end
