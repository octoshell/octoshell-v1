class TicketFieldRelation < ActiveRecord::Base
  attr_accessor :use
  
  belongs_to :ticket_field
  belongs_to :ticket_question
  
  validates :ticket_field, :ticket_question, presence: true
  
  attr_accessible :ticket_question_id, :ticket_field_id, :use, :required, as: :admin
end
