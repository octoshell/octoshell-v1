class TicketTagRelation < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :ticket_tag
  
  validates :ticket, :ticket_tag, presence: true
  
  attr_accessible :active, as: :admin
  
  scope :active, joins(:ticket_tag).where(ticket_tags: { state: 'active' })
end
