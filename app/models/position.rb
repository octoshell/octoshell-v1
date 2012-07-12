class Position < ActiveRecord::Base
  belongs_to :membership
  
  validates :membership, :name, :value, presence: true
  validates :name, uniqueness: { scope: :membership_id }
end
