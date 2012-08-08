class TicketFieldRelation < ActiveRecord::Base
  belongs_to :ticket_field
  belongs_to :ticket_question
  
  validates :ticket_field, :ticket_question, presence: true
  
  attr_accessible :use, :required, as: :admin
  
  scope :uses, where(use: true)
  
end
