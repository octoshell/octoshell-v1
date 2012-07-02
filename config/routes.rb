Mgu::Application.routes.draw do
  namespace :admin do
    resource :dashboard, only: :show
    resources :users do
      get :unconfirmed, on: :collection
    end
    resources :requests
  end
  
  resources :users, only: :create
  resources :sessions, only: [:new, :create, :destroy]
  resource :dashboard, only: :show
  resources :projects, only: [:index, :new, :create, :show]
  resources :requests do
    get :confirmation
  end
  
  root to: 'dashboards#show'
end
