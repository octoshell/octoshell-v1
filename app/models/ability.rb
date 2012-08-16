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
      
      can [:index, :show, :new, :create], :organizations
      
      can [:show, :index, :close], :memberships
      
      can [:index, :new, :create], :sureties
      can :show, :sureties, user_id: user.id
      
      can [:new, :create], :memberships
      
      can [:edit, :update], :memberships, user_id: user.id
      
      can [:new, :index], :accounts
      can [:show, :activate, :decline, :cancel], :accounts, project_id: user.owned_project_ids
      can :show, :cluster_users, project_id: user.project_ids
      
      # sured user
      if user.sured?
        can :new, :accounts
        # test it
        can :invite, :accounts, project_id: user.owned_project_ids
        # test it
        can :create, :accounts, user_id: user.id
        # test it
        can :mailer, :accounts, project_id: user.owned_project_ids
        
        can :show, :requests, user_id: user.id
        
        can [:new, :create], :requests
        
        can [:new, :create], :projects
        can [:edit, :update], :projects, user_id: user.id
      end
      
      if user.admin?
        can :access, :admins
        
        can :close, :tickets, can__close?: true
        
        can :create, :replies
        
        can :show, :accesses
        
        can :show, :cluster_users
        
        can [:index, :show, :perform_callbacks, :create, :retry], :tasks
        
        can [:new, :create, :edit, :update, :show, :index, :close], :ticket_questions
        
        can [:index, :show, :new, :create, :edit, :update, :close], :ticket_fields
        
        can :show, :accounts
        
        can [:show, :close], :credentials
        
        can [:activate, :decline, :cancel, :invite, :create, :mailer], :accounts
        
        can [:show, :edit, :update, :new, :create, :close], :projects
        
        can :show, :dashboard
        
        can [:admin, :edit, :update, :close], :users
        
        can [:index, :new, :create, :show, :activate, :decline, :close], :requests
        
        can [:index, :show, :activate, :decline, :close, :find], :sureties
        
        can [:index, :show, :edit, :update, :merge, :close], :organizations
        
        can [:index, :new, :create, :edit, :update, :destroy], :position_names
        
        can [:index, :new, :create, :show, :edit, :update, :close], :clusters
        
        can [:index, :show, :new, :create, :edit, :update, :close], :organization_kinds
        
        can [:index, :show, :new, :create, :edit, :update, :close], :ticket_templates
        
        can [:index, :show, :new, :create, :edit, :update, :close, :merge], :ticket_tags
        
        can [:index, :show], :versions
        
        can [:edit, :update, :tag_relations_form], :tickets
      end
    end
  end
end
