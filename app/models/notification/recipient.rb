class Notification::Recipient < ActiveRecord::Base
  belongs_to :notification
  belongs_to :user
  
  state_machine initial: :pending do
    state :pending
    state :delivered
    
    event :deliver do
      transition pending: :delivered
    end
    
    inside_transition on: :deliver, &:send_email
  end
  
  def send_email
    Mailer.delay.notification(self)
    notification.complete_delivering
  end
end
