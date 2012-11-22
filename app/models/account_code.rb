# coding: utf-8
class AccountCode < ActiveRecord::Base
  # has_paper_trail
  
  attr_accessor :full_name
  
  belongs_to :project
  belongs_to :user
  has_one :surety_member, inverse_of: :account_code
  
  validates :project, :surety_member, presence: true
  
  attr_accessible :email, :project_id
  
  before_create :assign_code
  after_create :send_invite, if: :email?
  
  state_machine initial: :pending do
    state :used do
      validates :user, presence: true
    end
    
    event :_use do
      transition pending: :used
    end
  end
  
  define_defaults_events :use
  
  def use(user)
    if can__use?
      transaction do
        self.user = user
        surety_member.user = user
        surety_member.save!
        user.revalidate!
        use!
      end
    else
      self.errors.add(:code, "уже использован")
      false
    end
  end
  
  def use!
    transaction do
      _use!
      account = Account.where(project_id: project_id, user_id: user_id).first_or_create!
      account.active? or account.activate!
    end
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
