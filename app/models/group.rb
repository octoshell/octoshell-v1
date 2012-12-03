class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :abilities, dependent: :destroy, order: "id"

  attr_accessible :name, :abilities_attributes
  accepts_nested_attributes_for :abilities

  after_create :create_abilities

  validates :name, presence: true, uniqueness: true

private
  
  def create_abilities
    Ability.definitions.each do |definition|
      abilities.create! do |a|
        a.definition = definition
      end
    end
    true
  end
end
