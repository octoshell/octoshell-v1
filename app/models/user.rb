class User < ActiveRecord::Base
  has_many :accounts
  has_many :credentials
  
  validates :first_name, :last_name, presence: true
end
