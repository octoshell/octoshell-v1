class Ability
  include CanCan::Ability

  def initialize(user)
    can :dashboard, :application
    
    can [:new, :create, :destroy], :sessions
    can [:new, :create, :confirmation, :change], :passwords
    
    can [:new, :create, :activate, :confirmation], :users
    
    can [:new, :create], :activations
    
    # basic user
    if user
      can :show, :support
      
      can [:show, :index], :pages
      
      can [:index, :new, :create, :show, :closed, :continue], :tickets
      can :resolve, :tickets do |ticket|
        (ticket.user_id == user.id) && ticket.can__resolve?
      end
      
      can :create, :replies, ticket_id: user.ticket_ids
      
      can [:show, :edit, :update], :profiles
      
      can [:index, :show], :clusters
      
      can [:index, :new, :create], :credentials
      can [:show, :close], :credentials, user_id: user.id
      
      can :show, :dashboards
      
      can [:index, :show], :projects
      can :close, :projects, user_id: user.id
      
      can [:index, :show], :users
      
      can [:index, :show, :new, :create, :closed], :organizations
      
      can [:show, :index, :close], :memberships
      
      can [:index, :new, :create], :sureties
      can :show, :sureties, user_id: user.id
      
      can [:new, :create], :memberships
      
      can [:edit, :update], :memberships, user_id: user.id
      
      can :index, :accounts
      can [:show, :activate, :decline, :cancel], :accounts, project_id: user.owned_project_ids
      can :show, :cluster_users do |cluster_user|
        cluster_user.account.user == user
      end
      
      # sured user
      if user.sured?
        can [:new, :show], :accounts
        can :invite, :accounts, project_id: user.owned_project_ids
        can [:application, :request], :accounts, user_id: user.id
        can :mailer, :accounts, project_id: user.owned_project_ids
        
        can :show, :requests, user_id: user.id
        
        can [:new, :create, :index], :requests
        
        can [:new, :create], :projects
        can [:edit, :update], :projects, user_id: user.id
      end
      
      if user.admin?
        can :access, :admins
        
        can [:new, :create, :edit, :update, :destroy], :pages
        
        can :close, :tickets, can__close?: true
        
        can :create, :replies
        
        can [:show, :index], :accesses
        
        can [:show, :index], :cluster_users
        
        can [:index, :show, :perform_callbacks, :create, :retry, :resolve], :tasks
        
        can [:new, :create, :edit, :update, :show, :index, :close], :ticket_questions
        
        can [:index, :show, :new, :create, :edit, :update, :close], :ticket_fields
        
        can [:show, :close], :credentials
        
        can [:new, :application, :show, :activate, :decline, :cancel, :invite, :request, :mailer, :edit, :update], :accounts
        
        can [:show, :edit, :update, :new, :create, :close], :projects
        
        can :show, :dashboard
        
        can [:admin, :edit, :update, :close], :users
        
        can [:index, :new, :create, :show, :activate, :decline, :close, :edit, :update, :application], :requests
        
        can [:index, :show, :activate, :decline, :close, :find], :sureties
        
        can [:index, :show, :edit, :update, :merge, :close], :organizations
        
        can [:index, :new, :create, :edit, :update, :destroy], :position_names
        
        can [:index, :new, :create, :show, :edit, :update, :close, :closed], :clusters
        
        can [:index, :show, :new, :create, :edit, :update, :close], :organization_kinds
        
        can [:index, :show, :new, :create, :edit, :update, :close], :ticket_templates
        
        can [:index, :show, :new, :create, :edit, :update, :close, :merge], :ticket_tags
        
        can [:index, :show], :versions
        
        can [:edit, :update, :tag_relations_form], :tickets
        
        can [:create, :update, :destroy], :wiki_urls
        
        can [:create, :update, :destroy], :cluster_fields
        
        can [:index, :show], :cluster_projects
        
        can [:index, :new, :create, :edit, :update, :destroy], :extends
      end
    end
  end
end
