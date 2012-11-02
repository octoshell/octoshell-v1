# coding: utf-8
class SuretyMember < ActiveRecord::Base
  belongs_to :surety, inverse_of: :surety_members
  belongs_to :user
  belongs_to :account_code
  
  validates :surety, :email, :full_name, presence: true
  validates :email, email_format: { message: 'имеет не верный формат' }
  
  attr_accessible :full_name, :email
  attr_accessible :full_name, :email, as: :admin
  
  before_create :create_account_code_for_user
  
private
  
  def create_account_code_for_user
    create_account_code! do |code|
      code.email = email
      code.project = surety.project
    end
    true
  end
end
