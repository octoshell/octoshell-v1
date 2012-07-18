class Credential < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :public_key, :name
  attr_accessible :public_key, :name, :user_id, as: :admin
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
end
