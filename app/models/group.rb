class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :group_abilities, dependent: :destroy
  has_many :abilities, through: :group_abilities

  attr_accessible :name, :group_abilities_attributes
  accepts_nested_attributes_for :group_abilities

  after_create :create_group_abilities

  validates :name, presence: true, uniqueness: true

private
  
  def create_group_abilities
    Ability.all.each do |ability|
      group_abilities.create! do |gp|
        gp.ability = ability
      end
    end
  end
end
