Mgu::Application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resource :profile, only: [:show, :edit, :update]
  resource :password, only: [:new, :create, :update] do
    get :confirmation
  end
  get 'password/:token' => 'passwords#edit', as: :edit_password
  resource :dashboard, only: :show
  
  # namespace :admin do
  #   resource :dashboard, only: :show
  #   resources :users do
  #     get :unconfirmed, on: :collection
  #   end
  #   resources :requests
  # end
  # 
  # 
  # 
  # resources :projects, only: [:index, :new, :create, :show]
  # resources :requests do
  #   get :confirmation
  # end
  
  root to: 'dashboards#show'
end
