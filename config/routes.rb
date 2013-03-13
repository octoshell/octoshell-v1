MSU::Application.routes.draw do
  # users
  get 'users/activate/:token' => 'users#activate', as: :activate_user
  get 'users/email' => 'users#email'
  resources :users, only: [:new, :create] do
    get :confirmation, on: :collection
  end
  resources :users, only: [:index, :show], as: :json

  # notifications
  resources :notifications, only: :index

  # activations
  resources :activations, only: [:new, :create]

  # credentials
  resources :credentials, only: [:new, :create, :show] do
    put :close
    resources :versions, only: [:index, :show], resource: 'Credential'
  end

  # sureties
  resources :sureties, only: [:index, :show] do
    put :close
    get :scan, action: :new_scan
    post :scan, action: :load_scan
  end

  # memberships
  resources :memberships, only: [:new, :create, :edit, :update, :show] do
    put :close
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
    get :invite
    post :sureties
    post :accounts
    get :close, action: :close_confirmation
    put :close
    resources :versions, only: [:index, :show], resource: 'Project'
  end

  # project joiners
  resources :project_joiners, only: [:new, :create], path: 'joins'

  # requests
  resources :requests, only: [:new, :create, :index, :show] do
    put :close
  end

  # accounts
  resources :accounts, only: [] do
    put :cancel
    resources :versions, only: [:index, :show], resource: 'Account'
  end

  # clusters
  resources :clusters, only: :index

  # additional emails
  resources :additional_emails, only: [:new, :create, :destroy]

  # pages
  resources :pages, only: [:index, :show]

  # organizations
  resources :organizations, only: [:new, :create, :index, :show]

  # repliesorts
  resources :reports, only: [:edit] do
    resources :projects, module: :reports, only: [:create, :destroy]
    put :personal
    put :survey
    put :projects_survey
    put :projects
    put :submit
    post :replies
  end

  resources :tickets, only: [:new, :create, :index, :show, :edit, :update] do
    post :continue, on: :collection
    put :close
    put :resolve
  end

  # replies
  resources :replies, only: :create
  
  # positions
  resources :positions, only: :index

  namespace :admin do
    # credentials
    resources :credentials, only: :destroy
    
    # users
    resources :users, only: [:index, :show, :edit, :update] do
      get :history
      put :close
      resources :versions, only: [:index, :show], resource: 'User'
    end

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

    # project prefixes
    resources :project_prefixes, only: [:new, :create, :index, :edit, :update, :destroy]

    # notifications
    resources :notifications, only: :index

    # groups
    resources :groups, only: [:index, :new, :create, :edit, :update, :show, :destroy]

    # sureties
    resources :sureties, only: [:index, :show] do
      collection do
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
      resources :versions, only: [:index, :show], resource: 'Surety'
    end

    # memberships
    resources :memberships, only: [:index, :edit, :update, :show] do
      put :close
      resources :versions, only: [:index, :show], resource: 'Membership'
    end

    # projects
    resources :projects, only: [:index, :show, :edit, :update] do
      put :close
      resources :versions, only: [:index, :show], resource: 'Project'
    end

    # requests
    resources :requests, only: [:index, :show, :edit, :update] do
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

    # cluster_users
    resources :cluster_users, only: [:index, :show, :new, :create, :edit, :update] do
      resources :versions, only: [:index, :show], resource: 'ClusterUser'
    end

    # clusters
    resources :clusters, only: [:new, :create, :index, :show, :edit, :update] do
      put :close
      resources :versions, only: [:index, :show], resource: 'Cluster'
    end

    # accesses
    resources :accesses, only: [:index, :show, :new, :create, :edit, :update] do
      resources :versions, only: [:index, :show], resource: 'Access'
    end
    
    # tasks
    resources :tasks, only: [:show, :index] do
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

    # position names
    resources :position_names, except: :show do
      resources :versions, only: [:index, :show], resource: 'PositionName'
    end

    # pages
    resources :pages

    # cluster projects
    resources :cluster_projects, only: [:index, :show, :new, :create, :edit, :update] do
      resources :versions, only: [:index, :show], resource: 'ClusterProject'
    end

    # critical technologies
    resources :critical_technologies, only: [:index, :new, :create, :edit, :update, :destroy]
    
    # direction of sciences
    resources :direction_of_sciences, only: [:index, :new, :create, :edit, :update, :destroy], path: 'directions_of_science'

    # ticket templates
    resources :ticket_templates, except: :destroy do
      put :close
      resources :versions, only: [:index, :show], resource: 'TicketTemplate'
    end

    # tickets
    resources :tickets, only: [:index, :show, :edit, :update] do
      get :tag_relations_form
      put :close
      post :accept
      resources :versions, only: [:index, :show], resource: 'Ticket'
    end

    # replies
    resources :replies, only: :create do
      resources :versions, only: [:index, :show], resource: 'Reply'
    end

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

    # reports
    resources :reports, only: [:show, :index] do
      collection do
        get '/assessed'
        get '/self', action: 'self_assessing'
        get '/all'
        get '/latecommers'
        get '/stats'
        get '/progress'
      end
      get :review
      post :replies
      post :comments
      put :begin_assessing
      put :decline
      put :assess
      get :supervise
      put :allow
      put :submit
      post :ticket
      resources :report_projects, only: :update
    end
    
    # sessions
    resources :sessions, only: [:new, :create, :index, :show]
    
    # surveys
    resources :surveys, only: :show do
      resources :survey_fields, except: :index, path: :fields
    end
  end

  root to: 'application#dashboard'
end
