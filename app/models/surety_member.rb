# coding: utf-8
class SuretyMember < ActiveRecord::Base
  belongs_to :surety, inverse_of: :surety_members
  belongs_to :user
  belongs_to :account_code
  
  validates :surety, :email, :full_name, presence: true
  validates :email, email_format: { message: 'имеет не верный формат' }
  
  attr_accessible :full_name, :email
  attr_accessible :full_name, :email, as: :admin
  
  before_create :assign_user
  before_create :create_account_code_for_user
  
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
    if user == surety.project.user
      conditions = { user_id: user_id, project_id: surety.project_id }
      account = Account.where(conditions).first_or_create!
      account.activate! unless account.active?
    else
      create_account_code! do |code|
        code.email = email
        code.project = surety.project
      end
    end
    true
  end
end
