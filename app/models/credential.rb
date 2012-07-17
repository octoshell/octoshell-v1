class Credential < ActiveRecord::Base
  include Models::Continuable
  
  belongs_to :user
  
  attr_accessible :public_key, :name
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
end
