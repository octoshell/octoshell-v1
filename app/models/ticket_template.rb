class TicketTemplate < ActiveRecord::Base
  validates :subject, presence: true
  
  attr_accessible :subject, :message, as: :admin
  
  state_machine :state, initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  define_state_machine_scopes
  
  
end
