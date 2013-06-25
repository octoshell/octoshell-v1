# coding: utf-8
class AccountCode < ActiveRecord::Base
  has_paper_trail
  
  attr_accessor :full_name
  
  belongs_to :project
  belongs_to :user
  has_one :surety_member, inverse_of: :account_code
  
  validates :project, :surety_member, presence: true
  
  attr_accessible :email, :project_id
  
  before_create :assign_code
  after_commit :send_invite, if: :email?, on: :create
  
  state_machine initial: :pending do
    state :pending
    state :used do
      validates :user, presence: true
    end
    
    event :mark_used do
      transition :pending => :used
    end
    
    inside_transition :on => :mark_used, &:activate_account!
  end
  
  def use(user)
    if can_mark_used?
      transaction do
        self.user = user
        surety_member.user = user
        surety_member.save!
        user.revalidate!
        mark_used!
      end
    else
      self.errors.add(:code, "уже использован")
      false
    end
  end
  
  def activate_account!
    condition = { project_id: project_id, user_id: user_id }
    account = Account.where(condition).first_or_create!
    account.allowed? or account.allow!
  end
  
  def obfuscated_email
    "#{email.to_s[/(.*)@/, 1]}@..."
  end
  
private
  
  def assign_code
    self.code = SecureRandom.hex
    true
  end
  
  def send_invite
    Mailer.invite(self).deliver
  end
end
