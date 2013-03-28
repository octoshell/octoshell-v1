class Membership < ActiveRecord::Base
  has_paper_trail
  
  # default_scope order("#{table_name}.id desc")
  
  delegate :state_name, to: :organization, prefix: true, allow_nil: true
  # delegate :id, to: :subdivision, prefix: true
  delegate :subdivision_ids, to: :organization
  
  attr_accessor :skip_revalidate_user
  
  belongs_to :user
  belongs_to :organization
  belongs_to :subdivision
  has_many :positions, inverse_of: :membership
  
  validates :user, :organization, presence: true
  # validates :subdivision_id, inclusion: { in: proc(&:organization_subdivision_ids) }, if: :subdivision
  validates :organization_state_name, exclusion: { in: [:closed] }, on: :create
  
  attr_accessible :organization_id, :positions_attributes, :subdivision_name
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
  define_state_machine_scopes
  
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
  
  def subdivision_name
    subdivision.try(:name)
  end
  
  def subdivision_name=(name)
    return unless organization
    self.subdivision = organization.subdivisions.find_or_create_by_name!(name)
  end
end
