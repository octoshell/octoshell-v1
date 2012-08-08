class TicketField < ActiveRecord::Base
  has_many :ticket_field_relations
  has_many :ticket_questions, through: :ticket_field_relations
  
  attr_accessible :name, :required, :hint, as: :admin
  
  validates :name, presence: true
end
