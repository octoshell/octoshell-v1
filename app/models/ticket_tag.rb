class TicketTag < ActiveRecord::Base
  include Models::Limitable
  
  attr_accessor :merge_id
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :ticket_tag_relations, dependent: :destroy
  has_many :tickets, through: :ticket_tag_relations
  
  validates :name, presence: true
  
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
  
  def merge(tag)
    return false if self == tag
    
    transaction do
      active_ticket_ids = tag.ticket_tag_relations.active.pluck(:ticket_id)
      ticket_tag_relations.where(ticket_id: active_ticket_ids).
        update_all(active: true)
      tag.destroy
    end
  end
  
private
  
  def create_ticket_tag_relations
    Ticket.all.each do |ticket|
      ticket_tag_relations.create! do |relation|
        relation.ticket = ticket
      end
    end
  end
end
