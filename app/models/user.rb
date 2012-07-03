class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  has_many :accounts
  has_many :credentials
  
  validates :first_name, :last_name, :email, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }
  validates :email, uniqueness: true
end
