class Position < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :membership, inverse_of: :positions
  
  validates :membership, :name, :value, presence: true
  validates :name, uniqueness: { scope: :membership_id }
  
  attr_accessible :name, :value
  attr_accessible :name, :value, as: :admin
  
  def try_save
    valid? ? save : errors.clear
  end
end
