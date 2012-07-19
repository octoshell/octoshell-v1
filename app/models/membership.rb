class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :positions, inverse_of: :membership, dependent: :destroy
  
  validates :user, :organization, presence: true
  
  attr_accessible :organization_id, :positions_attributes
  attr_accessible :organization_id, :positions_attributes, :user_id, as: :admin
  
  accepts_nested_attributes_for :positions, reject_if: proc { |a| a['value'].blank? }
  
  def build_default_positions
    @existed_positions = positions.to_a.dup
    
    self.class.transaction do
      self.positions = []
      PositionName.all.each do |position_name|
        positions.build do |position|
          position.name = position_name.name
          position.value = find_existed_position(position_name).try(:value)
          position.try_save
        end
      end
    end
  end
  
  def find_existed_position(position_name)
    @existed_positions.find do |p|
      p.name == position_name.name
    end
  end
end
