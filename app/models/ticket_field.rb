class TicketField < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :ticket_field_relations
  has_many :ticket_questions, through: :ticket_field_relations
  
  attr_accessible :name, :required, :hint, as: :admin
  
  validates :name, presence: true
  
  after_create :create_ticket_relations
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def hint
    self[:hint].blank? ? nil : self[:hint]
  end

  def link_name
    name
  end
  
private
  
  def create_ticket_relations
    TicketQuestion.all.each do |ticket_question|
      ticket_field_relations.create! do |ticket_field_relation|
        ticket_field_relation.ticket_question = ticket_question
      end
    end
  end
end
