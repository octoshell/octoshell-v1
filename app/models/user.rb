class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :accounts
  has_many :credentials
  
  validates :first_name, :last_name, presence: true
end
