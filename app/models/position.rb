class Position < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  belongs_to :membership, inverse_of: :positions
  
  validates :membership, :name, :value, presence: true
  validates :name, uniqueness: { scope: :membership_id }
  
  attr_accessible :name, :value
  attr_accessible :name, :value, as: :admin
  
  def try_save
    valid? ? save : errors.clear
  end
end
