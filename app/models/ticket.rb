class Ticket < ActiveRecord::Base
  attr_accessor :role
  include Models::Limitable
  
  has_paper_trail
  
  has_attached_file :attachment
  
  belongs_to :resource, polymorphic: true
  belongs_to :project
  belongs_to :cluster
  belongs_to :ticket_question
  belongs_to :user
  has_many :replies
  has_many :ticket_field_values, inverse_of: :ticket
  has_many :ticket_tag_relations
  has_many :ticket_tags, through: :ticket_tag_relations
  has_and_belongs_to_many :users, uniq: true
  
  validates :subject, :message, presence: true
  validates :ticket_question, presence: true, if: :user
  
  accepts_nested_attributes_for :ticket_field_values, :ticket_tag_relations
  
  attr_accessible :message, :subject, :attachment, :ticket_question_id, :url,
    :ticket_field_values_attributes, :project_id, :cluster_id
  attr_accessible :message, :subject, :attachment, :ticket_question_id, :url,
    :ticket_field_values_attributes, :user_id, :project_id, :cluster_id,
    :ticket_tag_relations_attributes, :user_ids, as: :admin
  
  after_create :create_ticket_tag_relations
  after_create :assign_special_tags, if: :role
  
  state_machine :state, initial: :pending do
    state :pending
    state :accepted
    state :resolved
    state :closed
  end
  
  state_machine :answer_state, initial: :pending do
    state :replied
    state :answered
    
    event :reply do
      transition any => :replied
    end
    
    event :answer do
      transition any => :answered
    end
  end
  
  define_state_machine_scopes
  
  def attachment_image?
    attachment_content_type.to_s =~ /image/
  end

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

  def link_name
    subject
  end
  
  def active_ticket_tags
    ticket_tags.where(ticket_tag_relations: { active: true })
  end
  
private
  
  def create_ticket_tag_relations
    TicketTag.all.each do |tag|
      ticket_tag_relations.create! do |relation|
        relation.ticket_tag = tag
        if ticket_question
          relation.active = ticket_question.ticket_tags.include?(tag)
        end
      end
    end
  end
  
  def assign_special_tags
    ticket_tag_relations.where({
      ticket_tag_id: TicketTag.send(role).id
    }).update_all(active: true)
  end
end
