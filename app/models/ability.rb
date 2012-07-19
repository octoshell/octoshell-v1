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
      
      can [:index, :show], :clusters
      
      can [:index, :new, :create], :credentials
      can [:show, :destroy], :credentials, user_id: user.id
      
      can :show, :dashboards
      
      can [:index, :show], :projects
      
      can [:index, :show], :users
      
      can [:index, :show, :new, :create], :organizations
      
      can [:show, :index], :memberships
      
      can [:index, :new, :create], :sureties
      can :show, :sureties, user_id: user.id
      
      can [:new, :create], :memberships
      
      can [:edit, :update], :memberships, user_id: user.id
      
      can [:new, :index], :accounts
      can [:show, :activate, :decline, :cancel], :accounts, project_id: user.owned_project_ids
      
      # sured user
      if user.sured?
        can [:new, :create], :projects
        
        can :new, :accounts
        # test it
        can :invite, :accounts, project_id: user.owned_project_ids
        # test it
        can :create, :accounts, user_id: user.id
        # test it
        can :mailer, :accounts, project_id: user.owned_project_ids
        
        if user.memberships.any?
          can [:new, :create], :requests
        end
      end
      
      if user.admin?
        can :access, :admins
        
        can [:index, :show], :tasks
        
        can :show, :accounts
        
        can [:show, :destroy], :credentials
        
        can [:activate, :decline, :cancel, :invite, :create, :mailer], :accounts
        
        can [:edit, :update, :new, :create], :projects
        
        can :show, :dashboard
        
        can [:admin, :edit, :update], :users
        
        can [:index, :new, :create, :show, :activate, :decline, :finish], :requests
        
        can [:index, :show, :activate, :decline, :cancel, :find], :sureties
        
        can [:index, :show, :edit, :update, :merge], :organizations
        
        can [:index, :new, :create, :edit, :update, :destroy], :position_names
        
        can [:index, :new, :create, :show, :edit, :update, :destroy], :clusters
      end
    end
  end
end
