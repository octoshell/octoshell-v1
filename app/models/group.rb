class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :abilities, dependent: :destroy, order: "id"

  attr_accessible :name, :abilities_attributes
  accepts_nested_attributes_for :abilities

  after_create :create_abilities

  validates :name, presence: true, uniqueness: true

  def self.superadmin
    find_or_create_by_name! 'superadmins' do |group|
      group.system = true
    end
  end

  def self.authorized
    find_or_create_by_name! 'authorized' do |group|
      group.system = true
    end
  end

private
  
  def create_abilities
    Ability.definitions.each do |definition|
      abilities.create! do |a|
        a.definition = definition
        a.available = (name == 'superadmins')
      end
    end
    true
  end
end
