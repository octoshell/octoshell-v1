# Ответ в тикете
class Reply < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id asc")
  
  has_attached_file :attachment
  
  delegate :answer!, :reply!, to: :ticket
  delegate :state_name, to: :ticket, prefix: true
  
  default_scope order(:id)
  
  belongs_to :user
  belongs_to :ticket, touch: true
  
  validates :user, :ticket, :message, presence: true
  validates :ticket_state_name, exclusion: { in: [:closed] },
    if: proc { |r| r.ticket.active? }
  
  attr_accessible :message, :ticket_id, :attachment
  
  after_create :answer!, if: :user_admin?
  after_create :reply!, unless: :user_admin?
  after_create :notify_users
  after_create :add_recepient
  
  def attachment_image?
    attachment_content_type.to_s =~ /image/
  end
  
  def user_admin?
    user != ticket.user
  end
  
private
  
  def notify_users
    (ticket.users - [user]).each do |user|
      Mailer.delay.new_ticket_answer(user, ticket)
    end
  end

  def link_name
    I18n.t('.reply')
  end
  
  def add_recepient
    ticket.users << user unless user.in?(ticket.users)
    true
  end
end
