# Тикет (Заявка в ТП)
class Ticket < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  has_attached_file :attachment
  
  belongs_to :user
  belongs_to :ticket_question
  belongs_to :project
  belongs_to :cluster
  belongs_to :surety
  has_many :replies
  has_many :ticket_field_values, inverse_of: :ticket
  has_many :ticket_tag_relations
  has_many :ticket_tags, through: :ticket_tag_relations
  has_and_belongs_to_many :users, uniq: true
  
  validates :user, :subject, :message, :ticket_question, presence: true
  
  accepts_nested_attributes_for :ticket_field_values, :ticket_tag_relations
  
  attr_accessible :message, :subject, :attachment, :ticket_question_id, :url,
    :ticket_field_values_attributes, :project_id, :cluster_id
  attr_accessible :message, :subject, :attachment, :ticket_question_id, :url,
    :ticket_field_values_attributes, :user_id, :project_id, :cluster_id,
    :ticket_tag_relations_attributes, :user_ids, as: :admin

  after_create :create_ticket_tag_relations
  after_create :add_user_to_receipients
  after_create :notify_support
  
  state_machine :state, initial: :active do
    state :active
    state :answered
    state :resolved
    state :closed
    
    event :answer do
      transition [:active, :resolved, :answered] => :answered
    end
    
    event :reply do
      transition [:active, :resolved, :answered] => :active
    end
    
    event :resolve do
      transition [:active, :answered] => :resolved
    end
    
    event :close do
      transition [:active, :resolved, :answered] => :closed
    end
  end
  
  def attachment_image?
    attachment_content_type.to_s =~ /image/
  end

  def accept(user)
    replies.create! do |reply|
      reply.user = user
      reply.message = I18n.t("ticket_accepted")
    end
  end
  
  def actual?
    not closed?
  end
  
  def ticket_questions
    if ticket_question
      ticket_question.ticket_questions
    else
      TicketQuestion.root.with_state(:active)
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
  
  def available_users
    users = []
    users << user
    Group.support.users.each do |user|
      users << user
    end
    users
  end

  def find_next_ticket_from(tickets_list)
    tickets_list = tickets_list || ""
    tickets = tickets_list.split(',')
    ticket_index = tickets.find_index(self.id.to_s)
    if ticket_index && (next_ticket_id = tickets[ticket_index.next])
      Ticket.find(next_ticket_id)
    end
  end

  def user_logins
    accounts = if project
                 user.accounts.where(project_id: project)
               else
                 user.accounts
               end

    accounts.map(&:login).join(", ")
  end
  
private
  
  def create_ticket_tag_relations
    TicketTag.all.each do |tag|
      ticket_tag_relations.create! do |relation|
        relation.ticket_tag = tag
        relation.active = ticket_question.ticket_tags.include?(tag)
      end
    end
  end
  
  def add_user_to_receipients
    users << user
  end
  
  def notify_support
    Group.support.users.without_state(:closed).each do |user|
      Mailer.delay.new_ticket(self, user)
    end
    true
  end
end
