class OrganizationKind < ActiveRecord::Base
  has_many :organizations
  
  validates :name, presence: true
  
  attr_accessible :name, :abbreviation, as: :admin
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  define_state_machine_scopes
end
