class Surety < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  belongs_to :organization
  
  validates :user, :organization, presence: true
  
  attr_accessible :organization_id
  attr_accessible :organization_id, :user_id, as: :admin
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :close
    
    event :_activate do
      transition pending: :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :decline, :close
  
  define_state_machine_scopes
  
  def activate!
    transaction do
      _activate!
      user.revalidate!
    end
  end
  
  def close!(message = nil)
    self.comment = message
    transaction do
      _close!
      user.revalidate!
    end
  end
end
