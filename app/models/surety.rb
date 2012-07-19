class Surety < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to :user
  belongs_to :organization
  
  validates :user, :organization, presence: true
  
  attr_accessible :organization_id
  attr_accessible :organization_id, :user_id, as: :admin
  
  scope :active, where(state: 'active')
  
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
    
    event :_cancel do
      transition active: :canceled
    end
  end
  
  define_defaults_events :activate, :decline, :cancel
end
