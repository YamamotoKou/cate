Rails.application.routes.draw do
  root 'static_pages#start'
  get '/home', to: 'static_pages#home'
  get  '/signup',  to: 'users#new'
  get '/edit', to: 'users#edit'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'	
  resources :users, only: [:index, :create, :new, :update, :destroy]
  resources :users, path: '/', only: [:show] do 
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
