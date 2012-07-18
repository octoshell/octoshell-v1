MSU::Application.routes.draw do
  # users
  get 'users/acitivate/:token' => 'users#activate', as: :activate_user
  resources :users, only: [:new, :create, :show] do
    get :confirmation, on: :collection
  end
  
  # credentials
  resources :credentials, only: [:index, :new, :create, :destroy]
  
  # sureties
  resources :sureties, only: [:new, :create, :show]
  
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
  resources :projects, only: [:index, :new, :create, :show]
  
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
  
  resource :admin, only: :show
    
  # # dashboard
  # resource :dashboard, only: :show
  
  # requests
  resources :requests, only: [:index, :show] do
    put :activate
    put :decline
    put :finish
  end
  
  # users
  resources :users
  
  # projects
  resources :projects
  
  # clusters
  resources :clusters
  
  # sureties
  resources :sureties, only: [:index, :show] do
    put :activate
    put :decline
    put :cancel
    post :find, on: :collection
  end
  
  # organizations
  resources :organizations, only: [:index, :show, :edit, :update] do
    put :merge
  end
  
  # position names
  resources :position_names, except: :show

  root to: 'application#dashboard'
end
