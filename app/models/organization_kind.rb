# Тип организации
class OrganizationKind < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :organizations
  
  validates :name, presence: true
  
  attr_accessible :name, as: :admin
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :close do
      transition :active => :closed
    end
    
    # todo: validate absence of organizations
  end

  def link_name
    name
  end
  
  def self.stats
    
  end
end
