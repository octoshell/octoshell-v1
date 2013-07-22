class User::Notice < ActiveRecord::Base
  belongs_to :user, class_name: :"::User"
  belongs_to :notice, class_name: :"::Notice"
  
  before_create :set_token
  
  validates :user, :notice, presence: true
  
  state_machine :state, initial: :pending do
    state :pending
    state :viewed
    
    event :view do
      transition :pending => :viewed
    end
  end
  
  state_machine :deliver_state, initial: :undelivered do
    state :undelivered
    state :delivered
    
    event :deliver do
      transition :undelivered => :delivered
    end
    
    inside_transition on: :deliver, &:send_email
  end
  
  def set_token
    self.token = SecureRandom.hex(16)
  end
  
  def send_email
    Mailer.delay.notice(self)
  end
end
