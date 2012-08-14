class TicketTag < ActiveRecord::Base
  has_many :ticket_tag_relations
  
  attr_accessible :name
  
  after_create :create_ticket_tag_relations
  
private
  
  def create_ticket_tag_relations
    Ticket.all.each do |ticket|
      ticket_tag_relations.create! do |relation|
        relation.ticket = ticket
      end
    end
  end
end
