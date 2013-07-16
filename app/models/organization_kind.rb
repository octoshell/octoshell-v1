# Тип организации
class OrganizationKind < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :organizations
  
  validates :name, presence: true
  
  attr_accessible :name, as: :admin
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q.mb_chars.downcase}%").order("name asc") }
  
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
  
  def as_json(options)
    { id: id, text: name }
  end
end
