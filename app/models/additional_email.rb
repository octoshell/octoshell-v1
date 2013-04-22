class AdditionalEmail < ActiveRecord::Base
  include Models::Limitable
  
  belongs_to :user
  
  validates :user, :email, presence: true
  
  attr_accessible :email
  attr_accessible :email, as: :admin
end
