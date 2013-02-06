class TicketTagRelation < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :ticket_tag
  
  validates :ticket, :ticket_tag, presence: true
  
  attr_accessible :active, as: :admin
  after_save :subscribe_users, if: :active?
  
  scope :active, joins(:ticket_tag).where(ticket_tags: { state: 'active' })
  
  def subscribe_users
    ticket_tag.groups.each do |group|
      ticket.users << (group.users - ticket.users)
    end
  end
end
