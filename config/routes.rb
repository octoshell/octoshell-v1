MSU::Application.routes.draw do  
  # users
  get 'users/activate/:token' => 'users#activate', as: :activate_user
  get 'users/email' => 'users#email'
  resources :users, only: [:new, :create, :show] do
    get :confirmation, on: :collection
    get :history
  end
  
  # notifications
  resources :notifications, only: :index
  
  # activations
  resources :activations, only: [:new, :create]
  
  # credentials
  resources :credentials, only: [:index, :new, :create, :show] do
    put :close
    resources :versions, only: [:index, :show], resource: 'Credential'
  end
  
  # sureties
  resources :sureties, only: [:index, :show] do
    collection do
      get :closed
      post :find
      get :template,     action: :edit_template
      put :template,     action: :update_template
      put :default,      action: :default_template
      put :rtf_template
      put :default_rtf
      get :rtf_template, action: :download_rtf_template
    end
    put :activate
    put :decline
    put :close
    put :confirm
    put :unconfirm
    get :scan, action: :new_scan
    post :scan, action: :load_scan
    resources :versions, only: [:index, :show], resource: 'Surety'
  end
  
  # memberships
  resources :memberships, only: [:index, :new, :create, :edit, :update, :show] do
    put :close
    resources :versions, only: [:index, :show], resource: 'Membership'
  end
  
  # sessions
  resource :session, only: [:new, :create, :destroy] do
    put :become
    put :revert
  end
  get '/session' => 'session#destroy'
  
  # profile
  resource :profile, only: [:show, :edit, :update]
  
  # passwords
  resource :password, only: [:new, :create, :update] do
    get :confirmation
  end
  get 'password/:token' => 'passwords#change', as: :change_password
  
  # projects
  resources :projects, only: [:index, :new, :create, :show, :edit, :update] do
    get :join, action: :join
    post :join, action: :create_account
    get :invite
    post :sureties
    post :accounts
    put :close
    resources :versions, only: [:index, :show], resource: 'Project'
  end
  
  # requests
  resources :requests, only: [:new, :create, :index, :show, :edit, :update] do
    put :activate
    put :decline
    put :close
    resources :versions, only: [:index, :show], resource: 'Request'
  end
  
  # organizations
  resources :organizations, only: [:new, :create, :index, :show, :edit, :update] do
    put :close
    put :merge
    get :closed, on: :collection
    resources :versions, only: [:index, :show], resource: 'Organization'
  end
  
  # invitation
  resources :invitations, only: [:new, :create]
  
  # accounts
  resources :accounts, only: [:index, :show, :edit, :update] do
    put :activate
    put :decline
    put :cancel
    resources :versions, only: [:index, :show], resource: 'Account'
  end
  
  # dashboard
  resource :dashboard, only: :show
  
  # admin dashboard
  resource :admin, only: :show
  
  # cluster_users
  resources :cluster_users, only: [:index, :show, :new, :create, :edit, :update] do
    resources :versions, only: [:index, :show], resource: 'ClusterUser'
  end
  
  # users
  resources :users, except: :destroy do
    put :close
    resources :versions, only: [:index, :show], resource: 'User'
  end
    
  # clusters
  resources :clusters do
    put :close
    get :closed, on: :collection
    resources :versions, only: [:index, :show], resource: 'Cluster'
  end
  
  # accesses
  resources :accesses, only: [:index, :show, :new, :create, :edit, :update] do
    resources :versions, only: [:index, :show], resource: 'Access'
  end
  
  # tasks
  resources :tasks, only: [:show, :create, :index] do
    put :retry
    put :perform_callbacks
    put :resolve
    resources :versions, only: [:index, :show], resource: 'Task'
  end
  
  # organization kinds
  resources :organization_kinds, except: [:destroy] do
    put :close
    resources :versions, only: [:index, :show], resource: 'OrganizationKind'
  end
  
  # tickets
  resources :tickets, only: [:new, :create, :index, :show, :edit, :update] do
    collection do
      get :closed
      post :continue
    end
    get :tag_relations_form
    put :close
    put :resolve
    resources :versions, only: [:index, :show], resource: 'Ticket'
  end
  
  # ticket templates
  resources :ticket_templates, except: :destroy do
    get :closed, on: :collection
    put :close
    resources :versions, only: [:index, :show], resource: 'TicketTemplate'
  end
  
  # replies
  resources :replies, only: :create do
    resources :versions, only: [:index, :show], resource: 'Reply'
  end
  
  # position names
  resources :position_names, except: :show do
    resources :versions, only: [:index, :show], resource: 'PositionName'
  end
  
  # support
  resource :support, only: :show
  
  # ticket questions
  resources :ticket_questions, except: :destroy do
    put :close
    resources :versions, only: [:index, :show], resource: 'TicketQuestion'
  end
  
  # ticket fields
  resources :ticket_fields, except: [:destroy] do
    put :close
    resources :versions, only: [:index, :show], resource: 'TicketField'
  end
  
  # ticket tags
  resources :ticket_tags, except: :destroy do
    put :merge
    put :close
    resources :versions, only: [:index, :show], resource: 'TicketTag'
  end
  
  # cluster projects
  resources :cluster_projects, only: [:index, :show, :new, :create, :edit, :update] do
    resources :versions, only: [:index, :show], resource: 'ClusterProject'
  end
  
  # additional emails
  resources :additional_emails, only: [:new, :create, :destroy]
  
  # pages
  resources :pages
  
  # cluster fields
  resources :cluster_fields, only: [:create, :update, :destroy]
  
  # extends
  resources :extends, only: [:index, :new, :create, :edit, :update, :destroy]
  
  # images
  resources :images, only: [:index, :new, :create, :destroy]
  
  # settings
  resource :settings, only: [:edit, :update]
  
  # import
  resources :import_items, only: [:new, :create, :index, :update, :destroy], path: 'import' do
    get :step, on: :collection
    put :import
  end

  root to: 'application#dashboard'
  
  mount Resque::Server.new, :at => '/resque'
end
