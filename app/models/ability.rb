class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :all
  end
end
