class Account < ActiveRecord::Base
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  
  validates :user, :project, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
  
  attr_accessible :project_id
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :canceled
    
    event :_activate do
      transition any => :active
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
  
  # test it
  def invite
    return if invalid?
    
    self.class.transaction do
      save! && activate!
    end
  end
end
