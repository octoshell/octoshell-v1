class Reply < ActiveRecord::Base
  delegate :answer!, :reply!, to: :ticket
  delegate :admin?, to: :user, prefix: true
  
  default_scope order('id desc')
  
  belongs_to :user
  belongs_to :ticket
  
  validates :user, :ticket, :message, presence: true
  
  after_create :answer!, if: :user_admin?
  after_create :reply!, unless: :user_admin?
  after_create :notify_user, if: :user_admin?
  
private
  
  def notify_user
    UserMailer.new_ticket_answer(ticket).deliver
  end
end
