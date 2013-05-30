class Notification < ActiveRecord::Base
  include Models::Limitable
  has_paper_trail
  
  has_many :receipents
  
  state_machine initial: :pending do
    state :pending
    state :delivering
    state :delivered
    
    event :deliver do
      transition :pending => :delivering
    end
    
    inside_transition on: :deliver, &:send_emails
  end
  
  def send_emails
    receipents.each &:send_email
  end
end
