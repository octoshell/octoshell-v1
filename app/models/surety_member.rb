class SuretyMember < ActiveRecord::Base
  belongs_to :surety
  belongs_to :user
  
  validates :surety, :user, presence: true
  
  attr_accessor :full_name, :email
end
