class AdditionalTicketField < ActiveRecord::Base
  belongs_to :ticket_question
  
  attr_accessible :name, :required, :hint
  
  validates :name, :ticket_question, presence: true
end
