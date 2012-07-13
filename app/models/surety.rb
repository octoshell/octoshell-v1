class Surety < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  
  validates :user, :organization, presence: true
  
  attr_accessible :organization_id
  
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
  
  def activate
    _activate
  end
  
  def decline
    _decline
  end
  
  def cancel
    _cancel
  end
end
