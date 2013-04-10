# coding: utf-8
class SuretyMember < ActiveRecord::Base
  belongs_to :surety, inverse_of: :surety_members
  belongs_to :user, inverse_of: :surety_members
  belongs_to :account_code, inverse_of: :surety_member
  
  validates :surety, :email, :full_name, presence: true, unless: :user
  validates :email, email_format: { message: 'имеет не верный формат' }, unless: :user
  
  before_create :refill_from_user, if: :user
  after_create :create_account_for_user, if: :user
  after_create :create_account_code_for_user, unless: :user
  
  def full_name
    u = user || User.new { |user| user.first_name = first_name; user.last_name = last_name; user.middle_name = middle_name }
    u.full_name
  end
  
private
  
  def refill_from_user
    self.last_name   = user.last_name
    self.first_name  = user.first_name
    self.middle_name = user.middle_name
    self.email       = user.email
    true
  end
  
  def create_account_for_user
    conditions = { user_id: user_id, project_id: surety.project_id }
    a = Account.where(conditions).first_or_create!
    a.allowed? || a.allow!
  end
  
  def create_account_code_for_user
    create_account_code! do |code|
      code.email = email
      code.project = surety.project
      code.surety_member = self
    end
  end
end
