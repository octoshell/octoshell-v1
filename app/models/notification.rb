class Notification < ActiveRecord::Base
  include Models::Limitable
  has_paper_trail
  
  validates :title, :body, presence: true
  
  attr_accessible :title, :body, as: :admin
  
  has_many :recipients, dependent: :destroy
  
  state_machine initial: :pending do
    state :pending
    state :delivering
    state :delivered
    
    event :deliver do
      transition :pending => :delivering
    end
    
    inside_transition on: :deliver, &:send_emails
  end
  
  def add_all_recipients
    transaction do
      User.without_state(:closed).each do |u|
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
  
  def test_send(user)
    rec = Recipient.new do |r|
      r.user = user
      r.notification = self
    end
    Mailer.notification(rec).deliver!
  end
  
  def remove_all_recipients
    recipients.delete_all
  end
  
  def send_emails
    recipients.each &:send_email
  end
end
