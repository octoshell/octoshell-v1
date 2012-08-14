class TicketTag < ActiveRecord::Base
  has_paper_trail
  
  has_many :ticket_tag_relations
  has_many :tickets, through: :ticket_tag_relations
  
  attr_accessible :name, as: :admin
  
  after_create :create_ticket_tag_relations
  
  state_machine :state, initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  define_state_machine_scopes
  
private
  
  def create_ticket_tag_relations
    Ticket.all.each do |ticket|
      ticket_tag_relations.create! do |relation|
        relation.ticket = ticket
      end
    end
  end
end
