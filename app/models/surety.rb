class Surety < ActiveRecord::Base
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
  
  %w(activate decline cancel).each do |event|
    define_method event do
      send "_#{event}"
    end
    
    define_method "#{event}!" do
      send "_#{event}!"
    end
  end
end
