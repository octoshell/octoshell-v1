# coding: utf-8
class SuretyMember < ActiveRecord::Base
  belongs_to :surety, inverse_of: :surety_members
  belongs_to :user
  
  validates :surety, :email, :full_name, presence: true
  validates :email, email_format: { message: 'имеет не верный формат' }
  
  attr_accessible :full_name, :email
  attr_accessible :full_name, :email, as: :admin
  
  after_commit :send_invite, on: :create
  
private
  
  def send_invite
    if user
      
    else
      
    end
  end
end
