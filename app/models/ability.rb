class Ability < ActiveRecord::Base
  has_many :group_abilities, dependent: :destroy

  validates :action, :subject, presence: true
  validates :action, uniqueness: { scope: [:subject] }

  attr_accessible :action, :subject

  after_create :create_group_abilities

  def action_name
    action.to_sym
  end

  def subject_name
    subject.to_sym
  end

private

  def create_group_abilities
    Group.all.each do |group|
      group_abilities.create! do |ga|
        ga.group = group
      end
    end
  end
end
