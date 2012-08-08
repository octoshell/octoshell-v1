class TicketFieldValue < ActiveRecord::Base
  belongs_to :ticket_field_relation
  belongs_to :ticket
  
  attr_accessible :ticket_field_id, :ticket_id, :value
  
  validates :ticket_field, :ticket, presence: true
  validates :value, presence: true, if: :required_value?
  
private
  
  def required_value?
    ticket_field_relation.try(:required?)
  end
end
