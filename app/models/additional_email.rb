class AdditionalEmail < ActiveRecord::Base
  include Models::Limitable
  
  belongs_to :user
  
  validates :user, :email, presence: true
  
  attr_accessible :email
end
