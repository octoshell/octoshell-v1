# Модель группы пользователей
class Group < ActiveRecord::Base
  SUPERADMINS = 'superadmins'
  AUTHORIZED = 'authorized'
  FAULTS_MANAGERS = 'faults_managers'
  EXPERTS = 'experts'
  
  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :abilities, dependent: :destroy, order: "id"

  attr_accessible :name, :abilities_attributes, as: :admin
  accepts_nested_attributes_for :abilities

  after_create :create_abilities

  validates :name, presence: true, uniqueness: true

  def self.superadmin
    find_or_create_by_name! SUPERADMINS do |group|
      group.system = true
    end
  end
  
  def self.experts
    find_or_create_by_name! EXPERTS do |group|
      group.system = true
    end
  end

  def self.authorized
    find_or_create_by_name! AUTHORIZED do |group|
      group.system = true
    end
  end
  
  def self.faults_managers
    find_or_create_by_name! FAULTS_MANAGERS do |group|
      group.system = true
    end
  end

private
  
  def create_abilities
    Ability.definitions.each do |definition|
      abilities.create! do |a|
        a.definition = definition
        a.available = (name == SUPERADMINS)
      end
    end
    true
  end
end
