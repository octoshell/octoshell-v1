class TicketFieldValue < ActiveRecord::Base
  belongs_to :ticket_field_relation
  belongs_to :ticket, inverse_of: :ticket_field_values
  
  attr_accessible :ticket_field_relation_id, :value
  attr_accessible :ticket_field_relation_id, :value, as: :admin
  
  validates :ticket_field_relation, :ticket, presence: true
  validates :value, presence: true, if: :required_value?
  
private
  
  def required_value?
    ticket_field_relation.try(:required?)
  end
end
