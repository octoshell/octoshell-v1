class Position < ActiveRecord::Base
  belongs_to :membership, inverse_of: :positions
  
  validates :membership, :name, :value, presence: true
  validates :name, uniqueness: { scope: :membership_id }
  
  attr_accessible :name, :value
  
  def try_save
    valid? ? save : errors.clear
  end
end
