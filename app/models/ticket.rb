class Ticket < ActiveRecord::Base
  belongs_to :user
  has_many :replies
  
  validates :user, :subject, :message, presence: true
  
  attr_accessible :message, :subject
  attr_accessible :message, :subject, :user_id, as: :admin
  
  state_machine :state, initial: :active do
    state :active
    state :answered
    state :resolved
    state :closed
    
    event :_answer do
      transition [:active, :resolved, :answered] => :answered
    end
    
    event :_reply do
      transition [:active, :answered] => :active
    end
    
    event :_resolve do
      transition [:active, :answered] => :resolved
    end
    
    event :_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :reply, :answer, :resolve, :close
  
  define_state_machine_scopes
end
