class AdditionalTicketFieldValue < ActiveRecord::Base
  delegate :required?, to: :additional_ticket_field, prefix: true, allow_nil: true
  
  belongs_to :additional_ticket_field
  belongs_to :ticket
  
  attr_accessible :additional_ticket_field_id, :ticket_id, :value
  
  validates :additional_ticket_field, :ticket, presence: true
  validates :value, presence: true, if: :additional_ticket_field_required?
end
