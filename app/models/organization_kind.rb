class OrganizationKind < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :organizations
  
  validates :name, presence: true
  
  attr_accessible :name, as: :admin
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      organizations.non_closed.each &:close!
    end
  end
end
