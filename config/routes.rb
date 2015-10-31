Myflix::Application.routes.draw do  
  root to: 'pages#front'    
  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]
  
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  resources :users, only: [:create, :show]   
  
  get '/people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  
  resources :invitations, only: [:new, :create]
  
  get '/home', to: 'videos#index'
  resources :videos, only: [:show, :index] do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end  
  
  resources :categories, only: [:show]  
  
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'pages#expired_token'
    
  get 'ui(/:action)', controller: 'ui'
end
