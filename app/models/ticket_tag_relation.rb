class TicketTagRelation < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :ticket_tag
  
  validates :ticket, :ticket_tag, presence: true
  
  attr_accessible :active
end
