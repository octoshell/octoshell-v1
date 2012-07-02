class Credential < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :public_key
  
  validates :user, :public_key, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
end
