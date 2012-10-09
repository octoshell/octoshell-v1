class Ability
  include CanCan::Ability

  def initialize(user)
    can :dashboard, :application
    
    can [:new, :create, :destroy], :sessions
    can [:new, :create, :confirmation, :change], :passwords
    
    can [:new, :create, :activate, :confirmation], :users
    
    can [:new, :create], :activations
    
    can [:show, :index], :pages
    
    # basic user
    if user
      can :show, :support
      
      can [:index, :new, :create, :show, :closed, :continue], :tickets
      can :resolve, :tickets do |ticket|
        (ticket.user_id == user.id) && ticket.can__resolve?
      end
      
      can :index, :notifications
      
      can :create, :replies, ticket_id: user.ticket_ids
      
      can [:show, :edit, :update], :profiles
      
      can [:index, :show], :clusters
      
      can [:index, :new, :create], :credentials
      can [:show, :close], :credentials, user_id: user.id
      
      can :show, :dashboards
      
      can :index, :projects
      can :show, :projects do |project|
        user.projects.where(accounts: { state: 'active' }).include?(project) || 
          user.owned_projects.include?(project)
      end
      can :close, :projects, user_id: user.id
      
      can :revert, :sessions
      
      can :show, :users do |showed_user|
        showed_user.id == user.id
      end
      
      can [:new, :create], :organizations
      
      can [:show, :index, :close], :memberships
      
      can [:index, :new, :create, :new_scan, :load_scan], :sureties
      can [:close, :show], :sureties, user_id: user.id
      
      can [:new, :create], :memberships
      
      can [:edit, :update], :memberships, user_id: user.id
      
      can :index, :accounts
      can [:activate, :decline, :cancel], :accounts, project_id: user.owned_project_ids
      
      # sured user
      if user.sured?
        can [:index, :create, :use, :new_use], :account_codes
        can :destroy, :account_codes do |code|
          code.pending? && user.owned_project_ids.include?(code.project_id)
        end
        
        can :show, :requests, user_id: user.id
        
        can [:new, :create, :index], :requests
        
        can [:new, :create], :projects
        can [:edit, :update], :projects, user_id: user.id
      end
      
      if user.admin?
        can :become, :sessions
        
        can [:edit_template, :update_template, :default_template, :rtf_template, :default_rtf, :download_rtf_template], :sureties
        
        can :access, :admins
        
        can [:new, :create, :edit, :update, :destroy], :pages
        
        can :close, :tickets, can__close?: true
        
        can :create, :replies
        
        can [:show, :index], :accesses
        
        can [:show, :index, :edit, :update, :new, :create], :cluster_users
        
        can [:index, :show, :perform_callbacks, :create, :retry, :resolve], :tasks
        
        can [:new, :create, :edit, :update, :show, :index, :close], :ticket_questions
        
        can [:index, :show, :new, :create, :edit, :update, :close], :ticket_fields
        
        can [:show, :close], :credentials
        
        can [:new, :create, :show, :activate, :decline, :cancel, :edit, :update], :accounts
        
        can [:show, :edit, :update, :new, :create, :close], :projects
        
        can :show, :dashboard
        
        can [:index, :admin, :edit, :update, :close, :show], :users
        
        can [:index, :new, :create, :show, :activate, :decline, :close, :edit, :update, :application], :requests
        
        can [:index, :show, :activate, :decline, :close, :find, :confirm, :unconfirm, :surety], :sureties
        
        can [:index, :show, :edit, :update, :merge, :close], :organizations
        
        can [:index, :new, :create, :edit, :update, :destroy], :position_names
        
        can [:index, :new, :create, :show, :edit, :update, :close, :closed], :clusters
        
        can [:index, :show, :new, :create, :edit, :update, :close], :organization_kinds
        
        can [:index, :show, :new, :create, :edit, :update, :close], :ticket_templates
        
        can [:index, :show, :new, :create, :edit, :update, :close, :merge], :ticket_tags
        
        can [:index, :show], :versions
        
        can [:edit, :update, :tag_relations_form], :tickets
        
        can [:create, :update, :destroy], :cluster_fields
        
        can [:index, :show, :new, :create, :edit, :update], :cluster_projects
        
        can [:index, :new, :create, :edit, :update, :destroy], :extends
        
        can [:edit, :update], :settings
        
        can [:index, :new, :create, :destroy], :images
      end
    end
  end
end
