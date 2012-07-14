MSU::Application.routes.draw do
  # users
  resources :users, only: [:new, :create] do
    get :confirmation, on: :collection
  end
  get 'users/:token' => 'users#activate', as: :activate_user
  
  # credentials
  resources :credentials, only: [:new, :create, :destroy]
  
  # sureties
  resources :sureties, only: [:new, :create, :show]
  
  # memberships
  resources :memberships, only: [:new, :create, :edit, :update]
  
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
  
  # clusters
  resources :clusters, only: :show
  
  # organizations
  resources :organizations, only: [:new, :create]
  
  # dashboard
  resource :dashboard, only: :show
  
  # admin namspace
  namespace :admin do
    # root
    get '/' => 'base#dashboard'
    
    # dashboard
    resource :dashboard, only: :show
    
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
  end

  root to: 'application#dashboard'
end
