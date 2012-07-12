class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :positions
  
  validates :user, :organization, presence: true
end
