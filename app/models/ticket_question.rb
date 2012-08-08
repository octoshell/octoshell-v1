class TicketQuestion < ActiveRecord::Base
  belongs_to :ticket_question, inverse_of: :ticket_questions
  has_many :ticket_questions, inverse_of: :ticket_question
  has_many :ticket_field_relations
  has_many :ticket_fields, through: :ticket_field_relations
  
  validates :question, presence: true
  validates :ticket_question_id, exclusion: { in: proc { |tq| [tq.id] } }, allow_nil: true
  
  before_create :assign_leaf
  
  scope :root, where(ticket_question_id: nil)
  
  accepts_nested_attributes_for :ticket_field_relations,
    reject_if: proc { |attrs| attrs['use'] == '0' }, allow_destroy: true
  
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
      ticket_question.update_attribute(:leaf, true) if ticket_question
      ticket_questions.each &:close!
      _close!
    end
  end
  
  def branch?
    not leaf?
  end
  
  def available_parents
    new_record? ? TicketQuestion.all : TicketQuestion.where('id != ?', id)
  end
  
  def available_field_relations
    ticket_fields = TicketField.scoped
    if ticket_field_ids.any?
      ticket_fields = ticket_fields.where('id not in (?)', ticket_field_ids)
    end
    ticket_fields.map do |ticket_field|
      TicketFieldRelation.new do |ticket_field_relation|
        ticket_field_relation.ticket_question = self
        ticket_field_relation.ticket_field = ticket_field
      end
    end
  end
  
private
  
  def assign_leaf
    if ticket_question && ticket_question.leaf?
      ticket_question.update_attribute(:leaf, false)
    end
    true
  end
end
