class Account < ActiveRecord::Base
  attr_accessor :raw_emails
  
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  
  validates :user, :project, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
  validate :emails_validator, if: :raw_emails
  
  attr_accessible :project_id, :raw_emails
  
  scope :pending, where(state: 'pending')
  scope :active, where(state: 'active')
  scope :declined, where(state: 'declined')
  scope :canceled, where(state: 'canceled')
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :canceled
    
    event :_activate do
      transition any => :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_cancel do
      transition active: :canceled
    end
  end
  
  %w(activate decline cancel).each do |event|
    define_method event do
      send "_#{event}"
    end

    define_method "#{event}!" do
      send "_#{event}!"
    end
  end
  
  # test it
  def send_invites
    emails_validator
    return if errors.any?
    
    UserMailer.invitation(self).deliver
  end
  
  # test it
  def invite
    return if invalid?
    
    self.class.transaction do
      save! && activate!
    end
  end
  
  # test it
  def emails
    raw_emails.to_s.split(',').map &:strip
  end
  
private
  
  def emails_validator
    emails.each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        errors.add(:raw_emails, :invalid_email, email: email)
      end
    end
  end
end
