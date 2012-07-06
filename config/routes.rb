MSU::Application.routes.draw do
  # users
  resources :users, only: [:new, :create]
  get 'users/:token' => 'users#activate', as: :activate_user
  
  # sessions
  resource :session, only: [:new, :create, :destroy]
  
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
  resources :requests do
    get :confirmation
  end
  
  # clusters
  resources :clusters, only: :show
  
  # dashboard
  resource :dashboard, only: :show

  root to: 'dashboards#show'
end
