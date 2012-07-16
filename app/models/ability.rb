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
      
      can [:new, :create, :show], :sureties
      
      can [:new, :create, :edit, :update], :memberships
      
      can [:activate, :decline, :destroy], :accounts, project_id: user.owned_project_ids
      
      # sured user
      if user.sured?
        can [:new, :create], :projects
        
        if user.memberships.any?
          can [:new, :create], :requests
        end
      end
      
      if user.admin?
        can :access, :admin
        
        can :dashboard, :'admin/base'
        
        can :show, :'admin/dashboards'
        
        can [:index, :show, :activate, :decline, :finish], :'admin/requests'
        
        can [:index, :show, :activate, :decline, :cancel, :find], :'admin/sureties'
        
        can [:index, :show, :edit, :update, :merge], :'admin/organizations'
        
        can [:index, :new, :create, :edit, :update, :destroy], :'admin/position_names'
        
        can [:index, :new, :create, :show, :edit, :update, :destroy], :'admin/clusters'
      end
    end
  end
end
