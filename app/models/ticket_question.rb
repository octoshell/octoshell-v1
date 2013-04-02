class TicketQuestion < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  default_scope order("#{table_name}.question asc")
  
  belongs_to :ticket_question, inverse_of: :ticket_questions
  has_many :ticket_questions, inverse_of: :ticket_question
  has_many :ticket_field_relations
  has_many :ticket_fields, through: :ticket_field_relations
  has_and_belongs_to_many :ticket_tags
  
  validates :question, presence: true
  validates :ticket_question_id, exclusion: { in: proc { |tq| [tq.id] } }, allow_nil: true
  
  after_create :create_ticket_relations
  after_save :assign_leaf!
  
  scope :root, where(ticket_question_id: nil)
  
  accepts_nested_attributes_for :ticket_field_relations
  
  attr_accessible :question, :ticket_question_id,
    :ticket_field_relations_attributes, :ticket_tag_ids, as: :admin
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :close do
      transition active: :closed
    end
    
    inside_transition :on => :close do |tq|
      tq.ticket_questions.without_state(:closed).each &:close!
    end
  end
  
  def branch?
    not leaf?
  end
  
  def available_parents
    new_record? ? TicketQuestion.scoped : TicketQuestion.where('id != ?', id)
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
  
  def assign_leaf!
    ticket_question.try(:assign_leaf!)
    if ticket_question_id_was && ticket_question_id_changed?
      self.class.find(ticket_question_id_was).assign_leaf!
    end
    self.class.where(id: id).update_all(leaf: !ticket_questions.active.exists?)
    true
  end

  def link_name
    question
  end

private
  
  def create_ticket_relations
    TicketField.active.each do |ticket_field|
      ticket_field_relations.create! do |ticket_field_relation|
        ticket_field_relation.ticket_field = ticket_field
      end
    end
  end
end
