MSU::Application.routes.draw do
  # users
  get 'users/activate/:token' => 'users#activate', as: :activate_user
  resources :users, only: [:new, :create, :show] do
    get :confirmation, on: :collection
  end
  
  # activations
  resources :activations, only: [:new, :create]
  
  # credentials
  resources :credentials, only: [:index, :new, :create, :show] do
    put :close
  end
  
  # sureties
  resources :sureties, only: [:new, :create, :index, :show] do
    put :activate
    put :decline
    put :close
    post :find, on: :collection
  end
  
  # memberships
  resources :memberships, only: [:index, :new, :create, :edit, :update, :show]
  
  # sessions
  resource :session, only: [:new, :create, :destroy]
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
    put :close
  end
  
  # requests
  resources :requests, only: [:new, :create]
  
  # organizations
  resources :organizations, only: [:new, :create]
  
  # invitation
  resources :invitations, only: [:new, :create]
  
  # accounts
  resources :accounts, only: [:index, :new, :create, :show] do
    collection do
      post :invite
      post :mailer
    end
    put :activate
    put :decline
    put :cancel
  end
  
  # dashboard
  resource :dashboard, only: :show
  
  # admin dashboard
  resource :admin, only: :show
  
  # requests
  resources :requests, only: [:index, :show] do
    put :activate
    put :decline
    put :close
  end
  
  # cluster_users
  resources :cluster_users, only: :show
  
  # users
  resources :users
    
  # clusters
  resources :clusters do
    put :close
  end
  
  # accesses
  resources :accesses, only: :show
  
  # tasks
  resources :tasks, only: [:show, :create, :index] do
    get :retry
    put :perform_callbacks
  end
  
  # organizations
  resources :organizations, only: [:index, :show, :edit, :update] do
    put :merge
  end
  
  # organization kinds
  resources :organization_kinds, except: [:destroy] do
    put :close
  end
  
  # tickets
  resources :tickets, only: [:new, :create, :index, :show] do
    get :closed, on: :collection
    put :close
    put :resolve
    post :continue, on: :collection
  end
  
  # ticket templates
  resources :ticket_templates, except: :destroy do
    get :closed, on: :collection
    put :close
  end
  
  # replies
  resources :replies, only: :create
  
  # position names
  resources :position_names, except: :show
  
  # support
  resource :support, only: :show
  
  # ticket questions
  resources :ticket_questions, except: :destroy do
    put :close
  end
  
  # additional ticket fields
  resources :ticket_fields, except: [:destroy] do
    put :close
  end

  root to: 'application#dashboard'
  
  mount Resque::Server.new, :at => '/resque'
end
