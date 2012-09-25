# coding: utf-8
class AccountCode < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :project
  belongs_to :user
  
  validates :project, presence: true
  
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
      self.user = user
      use!
    else
      self.errors.add(:code, "уже использован")
      false
    end
  end
  
private
  
  def assign_code
    self.code = SecureRandom.hex
    true
  end
  
  def send_invite
    UserMailer.invite(self).deliver
  end
end
