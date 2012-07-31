class Membership < ActiveRecord::Base
  has_paper_trail
  
  attr_accessor :skip_revalidate_user
  
  belongs_to :user
  belongs_to :organization
  has_many :positions, inverse_of: :membership
  
  validates :user, :organization, presence: true
  
  attr_accessible :organization_id, :positions_attributes
  attr_accessible :organization_id, :positions_attributes, :user_id, as: :admin
  
  accepts_nested_attributes_for :positions, reject_if: proc { |a| a['value'].blank? }
  
  after_create :revalidate_user, unless: :skip_revalidate_user
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  def close!
    transaction do
      _close!
      revalidate_user
    end
  end
  
  def build_default_positions
    @existed_positions = positions.to_a.dup
    
    transaction do
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
  
  def revalidate_user
    user.revalidate!
  end
end
