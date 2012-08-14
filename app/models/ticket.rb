class Ticket < ActiveRecord::Base
  has_paper_trail
  
  has_attached_file :attachment
  
  belongs_to :user
  belongs_to :ticket_question
  belongs_to :project
  belongs_to :cluster
  has_many :replies
  has_many :ticket_field_values, inverse_of: :ticket
  has_many :ticket_tag_relations
  
  validates :user, :subject, :message, :ticket_question, presence: true
  
  accepts_nested_attributes_for :ticket_field_values, :ticket_tag_relations
  
  attr_accessible :message, :subject, :attachment, :ticket_question_id, :url,
    :ticket_field_values_attributes, :project_id, :cluster_id
  attr_accessible :message, :subject, :attachment, :ticket_question_id, :url,
    :ticket_field_values_attributes, :user_id, :project_id, :cluster_id,
    :ticket_tag_relations_attributes, as: :admin
    
  after_create :create_ticket_tag_relations
  
  state_machine :state, initial: :active do
    state :active
    state :answered
    state :resolved
    state :closed
    
    event :_answer do
      transition [:active, :resolved, :answered] => :answered
    end
    
    event :_reply do
      transition [:active, :resolved, :answered] => :active
    end
    
    event :_resolve do
      transition [:active, :answered] => :resolved
    end
    
    event :_close do
      transition [:active, :resolved, :answered] => :closed
    end
  end
  
  define_defaults_events :reply, :answer, :resolve, :close
  
  define_state_machine_scopes
  
  def actual?
    not closed?
  end
  
  def ticket_questions
    if ticket_question
      ticket_question.ticket_questions
    else
      TicketQuestion.root.active
    end
  end
  
  def show_questions?
    !ticket_question || ticket_question.branch?
  end
  
  def show_form?
    ticket_question && ticket_question.leaf?
  end
  
private
  
  def create_ticket_tag_relations
    TicketTag.all.each do |tag|
      ticket_tag_relations.create! do |relation|
        relation.ticket_tag = tag
      end
    end
  end
end
