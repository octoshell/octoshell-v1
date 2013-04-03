# coding: utf-8
class SuretyMember < ActiveRecord::Base
  belongs_to :surety, inverse_of: :surety_members
  belongs_to :user, inverse_of: :surety_members
  belongs_to :account_code, inverse_of: :surety_member
  
  validates :surety, :email, :full_name, presence: true
  validates :email, email_format: { message: 'имеет не верный формат' }
  
  attr_accessible :full_name, :email
  
  before_create :assign_user
  after_create :create_account_code_for_user
  
  def email=(email)
    self[:email] = email.to_s.downcase
    self.full_name ||= User.find_by_email(email).try(:full_name)
  end
  
private
  
  def assign_user
    self.user ||= User.find_by_email(email)
    true
  end
  
  def create_account_code_for_user
    # if user
    #   conditions = { user_id: user_id, project_id: surety.project_id }
    #   account = Account.where(conditions).first_or_create!
    # else
    #   create_account_code! do |code|
    #     code.email = email
    #     code.project = surety.project
    #     code.surety_member = self
    #   end
    # end
    true
  end
end
