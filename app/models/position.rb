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
  
  delegate :values, :available_values, to: :position_name
  
  def position_name
    PositionName.find_by_name(name) || PositionName.new
  end
end
