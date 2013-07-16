# Модель группы пользователей
class Group < ActiveRecord::Base
  SUPERADMINS = 'superadmins'
  AUTHORIZED = 'authorized'
  FAULTS_MANAGERS = 'faults_managers'
  EXPERTS = 'experts'
  SUPPORT = 'support'
  DEFAULTS = [SUPERADMINS, AUTHORIZED, FAULTS_MANAGERS, EXPERTS, SUPPORT]
  
  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :abilities, dependent: :destroy, order: "id"

  attr_accessible :name, :abilities_attributes, as: :admin
  accepts_nested_attributes_for :abilities

  after_create :create_abilities

  validates :name, presence: true, uniqueness: true
  
  class << self
    [SUPERADMINS, AUTHORIZED, FAULTS_MANAGERS, EXPERTS, SUPPORT].each do |name|
      define_method name do
        find_or_create_by_name! name do |group|
          group.system = true
        end
      end
    end
  end
  
  def self.default!
    transaction do
      DEFAULTS.each do |group|
        self.send(group).abilities.update_all available: false
      end
    end
    superadmins.abilities.update_all available: true
    defaults = YAML.load_file "#{Rails.root}/config/groups.yml.default"
    defaults.each do |group, abilities|
      abilities.each do |subject, actions|
        send(group).abilities.where(subject: subject, action: actions).
          update_all(available: true)
      end
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
