class GroupAbility < ActiveRecord::Base
  belongs_to :group
  belongs_to :ability

  validates :group, :ability, presence: true

  attr_accessible :available
end
