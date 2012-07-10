MSU::Application.routes.draw do
  # users
  resources :users, only: [:new, :create]
  get 'users/:token' => 'users#activate', as: :activate_user
  
  # credentials
  resources :credentials, only: [:new, :create, :destroy]
  
  # confirmations
  resources :confirmations, only: [:new, :create, :show]
  
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
  
  # dashboard
  resource :dashboard, only: :show

  root to: 'application#dashboard'
end
