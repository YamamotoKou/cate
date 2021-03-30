Rails.application.routes.draw do
  root 'static_pages#start'
  get '/home', to: 'static_pages#home'
  get  '/signup',  to: 'users#new'
  get '/edit', to: 'users#edit'
  get '/users', to: 'users#index'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users, path: '/', only: [:show, :destroy] do
    member do
      get :following, :followers, :likes
    end
  end
  resources :users, only: [:create, :new, :update]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :microposts,          only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]

  resources :relationships,       only: [:create, :destroy]
  resources :rooms, only: [:create, :show]
  resources :direct_messages, only: [:create]
end