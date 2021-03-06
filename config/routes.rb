MSU::Application.routes.draw do
  # users
  get 'users/activate/:token' => 'users#activate', as: :activate_user
  get 'users/email' => 'users#email'
  resources :users, only: [:new, :create] do
    get :confirmation, on: :collection
  end
  resources :users, only: [:index, :show], as: :json
  
  get "/notices/:token/view" => "notices#view", as: :view_notice
  
  post '/markdown', to: 'markdown#create'

  # activations
  resources :activations, only: [:new, :create]

  # credentials
  resources :credentials, only: [:new, :create, :show] do
    put :close
    resources :versions, only: [:index, :show], resource: 'Credential'
  end
  
  resources :organization_kinds, only: [:index]

  # sureties
  resources :sureties, only: :show do
    put :generate
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
    post :members
    get "members/csv", action: :new_members_csv
    post "members/csv", action: :members_csv
    get :invite
    post :sureties
    get :close, action: :close_confirmation
    put :close
    put :resurrect
    resources :account_codes, only: :destroy
  end

  # project joiners
  resources :project_joiners, only: [:new, :create], path: 'joins'

  # requests
  resources :requests, only: [:create, :show, :update] do
    put :close
  end

  # accounts
  put '/accounts/:account_id/deny' => 'accounts#deny', as: :account_deny
  
  delete '/surety_members/:id' => 'surety_members#destroy', as: :surety_member
  
  # clusters
  resources :clusters, only: :index

  # additional emails
  resources :additional_emails, only: [:new, :create, :destroy]

  # pages
  resources :pages, only: [:index, :show]

  # organizations
  resources :organizations, only: [:new, :create, :index, :show] do
    get :subdivisions, only: [:index]
  end

  resources :countries, only: :index do
    resources :cities, only: [:index, :show]
  end

  # reports
  resources :reports, only: [:show] do
    put :accept
    put :submit
    put :resubmit
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
  
  # user surveys
  resources :user_surveys, path: :surveys, only: [:show, :update] do
    put :accept
    put :submit
  end
  
  # faults
  resources :faults, only: :show do
    resources :fault_replies, only: :create
  end
  
  namespace :api do
    get    "/projects"                                              => "projects#index", as: :json
    get    "/projects/:id"                                          => "projects#show", as: :json
    post   "/notifications"                                         => "notifications#create", as: :json
    put    "/notifications/:id/deliver"                             => "notifications#deliver", as: :json
    delete "/notifications/:id/recipients"                          => "notifications#destroy_recipients", as: :json
    put    "/notifications/:id/add_all_users"                       => "notifications#add_all_users", as: :json
    put    "/notifications/:id/add_all_info_subscribers"            => "notifications#add_all_info_subscribers", as: :json
    put    "/notifications/:id/add_from_cluster"                    => "notifications#add_from_cluster", as: :json
    put    "/notifications/:id/add_from_organization_kind"          => "notifications#add_from_organization_kind", as: :json
    put    "/notifications/:id/add_from_organization"               => "notifications#add_from_organization", as: :json
    put    "/notifications/:id/add_from_project"                    => "notifications#add_from_project", as: :json
    put    "/notifications/:id/add_with_projects"                   => "notifications#add_with_projects", as: :json
    put    "/notifications/:id/add_with_accounts"                   => "notifications#add_with_accounts", as: :json
    put    "/notifications/:id/add_with_refused_accounts"           => "notifications#add_with_refused_accounts", as: :json
    put    "/notifications/:id/add_from_session"                    => "notifications#add_from_session", as: :json
    put    "/notifications/:id/add_unsuccessful_of_current_session" => "notifications#add_unsuccessful_of_current_session", as: :json
    put    "/notifications/:id/add_user"                            => "notifications#add_user", as: :json
  end

  namespace :admin do
    resources :countries, only: [:index, :destroy]

    resources :cohortes, only: :index do
      post :calc, on: :collection
    end
    
    # credentials
    resources :credentials, only: :destroy
    
    # users
    resources :users, only: [:index, :show, :edit, :update] do
      get :delivered_mails
      get :history
      put :close
      resources :versions, only: [:index, :show], resource: 'User'
    end
    
    resource :console, only: [:show]

    # cluster fields
    resources :cluster_fields, only: [:create, :update, :destroy]
    
    # extends
    resources :extends, only: [:index, :new, :create, :edit, :update, :destroy]
    
    # images
    resources :images, only: [:index, :new, :create, :destroy]
    
    # settings
    resource :settings, only: [:show, :update]
    
    # import
    resources :import_items, only: [:new, :create, :index, :update, :destroy], path: 'import' do
      get :step, on: :collection
      put :import
    end

    # project prefixes
    resources :project_prefixes, only: [:new, :create, :index, :edit, :update, :destroy]

    # notifications
    resources :notifications do
      put :test
      put :deliver
      put :remove_all_recipients
      put :add_all_recipients
      put :add_all_info_subscribers
      put :add_from_cluster
      put :add_from_organization_kind
      put :add_from_organization
      put :add_from_project
      put :add_with_projects
      put :add_with_accounts
      put :add_with_refused_accounts
      put :add_from_session
      put :add_unsuccessful_of_current_session
      
      # notification_recipients
      resources :notification_recipients, only: [:create, :destroy]
    end
    
    resources :notices do
      put :deliver
      put :remove_all_recipients
      post :add_user
      delete :remove_user
      put :add_all_recipients
      put :add_from_cluster
      put :add_from_organization_kind
      put :add_from_organization
      put :add_from_project
      put :add_with_projects
      put :add_with_accounts
      put :add_with_refused_accounts
      put :add_from_session
      put :add_unsuccessful_of_current_session
    end

    # groups
    resources :groups do
      put :default, on: :collection
    end

    # memberships
    resources :memberships, only: :index

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
      put :synch
      put :close
      put :enable
      put :erase
      put :reactivate
      put :move_to
      post :block
      resources :versions, only: [:index, :show], resource: 'Project'
    end
    
    resources :accounts, only: [] do
      get :change
      post :block
      put :change_check
      put :change_confirmation
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
      resources :subdivisions, except: :show do
        put :merge
      end
      resources :versions, only: [:index, :show], resource: 'Organization'
    end

    # clusters
    resources :clusters, only: [:new, :create, :index, :show, :edit, :update] do
      get :logs
      put :close
      resources :versions, only: [:index, :show], resource: 'Cluster'
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
      post :update_subscribers
      put :close
      put :reactivate
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
      put :pick
      put :assess
      put :reject
      put :edit
      post :replies
    end
        
    # sessions
    resources :sessions, only: [:new, :create, :index, :show] do
      put :start
      put :stop
      put :download
      resources :stats, expect: [:index, :show]
    end
    
    get "/stats/:stat_id/download" => "stats#download", as: :stat_download
    get "/stats/:stat_id/detail" => "stats#detail", as: :stat_detail
    
    # surveys
    resources :surveys, only: :show do
      resources :survey_fields, except: :index, path: :fields
    end
    
    # user surveys
    resources :user_surveys, only: :show
    
    # research areas
    resources :research_areas, except: :show
    
    # faults
    resources :faults, only: [:index, :show] do
      put :resolve
      
      resources :fault_replies, only: [:create]
    end
  end
  
  match "/dj", to: DelayedJobWeb, anchor: false

  root to: 'application#dashboard'
end
