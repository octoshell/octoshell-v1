class Ability
  include CanCan::Ability

  def initialize(user)
    can :dashboard, :application
    
    can [:new, :create, :destroy], :sessions
    can [:new, :create, :confirmation, :change], :passwords
    
    can [:new, :create, :activate, :confirmation], :users
    
    # basic user
    if user
      can [:show, :edit, :update], :profiles
      
      can [:new, :create, :destroy], :credentials
      
      can :show, :dashboards
      
      can [:new, :create], :organizations
      can [:new, :create], :sureties
      
      # sured user
      if user.sured?
        can [:new, :create], :requests
        
        can [:new, :create], :projects
      end
      
      if user.admin?
        can :access, :admin
        
        can :dashboard, :'admin/base'
        
        can :show, :'admin/dashboards'
      end
    end
  end
end
