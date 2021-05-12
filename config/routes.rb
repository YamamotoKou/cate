Rails.application.routes.draw do
  root 'static_pages#start'
  get '/home', to: 'microposts#home'
  get '/search', to: 'microposts#search'
  get  '/signup',  to: 'users#new'
  get '/users', to: 'users#index'
  get '/bookmarks', to: 'bookmarks#show'
  get '/notifications', to: 'notifications#index'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users, path: '/', only: [:show, :destroy, :update, :edit] do
    member do
      get :following, :followers, :likes
    end
  end
  resources :users,               only: [:create, :new]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:show, :create, :destroy, :new] do
    resources :contents,          only: [:index, :show]
    resources :bookmarks,         only: [:create, :destroy]
    resources :likes,             only: [:create, :destroy]
  end
  resources :contents,            only: [:create, :destroy]
  resources :transaction_logs,    only: [:create]
  resources :point_histories,     only: [:create]
  resources :relationships,       only: [:create, :destroy]
  resources :rooms,               only: [:create, :show]
  resources :direct_messages,     only: [:create]
end