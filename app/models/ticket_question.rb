class TicketQuestion < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :ticket_question, inverse_of: :ticket_questions
  has_many :ticket_questions, inverse_of: :ticket_question
  has_many :ticket_field_relations
  has_many :ticket_fields, through: :ticket_field_relations
  
  validates :question, presence: true
  validates :ticket_question_id, exclusion: { in: proc { |tq| [tq.id] } }, allow_nil: true
  
  before_create :assign_leaf
  after_create :create_ticket_relations
  
  scope :root, where(ticket_question_id: nil)
  
  accepts_nested_attributes_for :ticket_field_relations
  
  attr_accessible :question, :ticket_question_id,
    :ticket_field_relations_attributes, as: :admin
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      ticket_question.update_attribute(:leaf, true) if ticket_question
      update_attribute(:leaf, true)
      ticket_questions.non_closed.each &:close!
    end
  end
  
  def branch?
    not leaf?
  end
  
  def available_parents
    new_record? ? TicketQuestion.all : TicketQuestion.where('id != ?', id)
  end
  
  def breadcrumbs
    breadcrumbs = [self]
    
    if ticket_question
      breadcrumbs << ticket_question
      
      current_question = ticket_question
      while ticket_question = current_question.ticket_question
        current_question = ticket_question
        breadcrumbs << current_question
      end
    end
    
    breadcrumbs.reverse
  end
  
private
  
  def assign_leaf
    if ticket_question && ticket_question.leaf?
      ticket_question.update_attribute(:leaf, false)
    end
    true
  end
  
  def create_ticket_relations
    TicketField.active.each do |ticket_field|
      ticket_field_relations.create! do |ticket_field_relation|
        ticket_field_relation.ticket_field = ticket_field
      end
    end
  end
end