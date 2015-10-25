Myflix::Application.routes.draw do  
  root to: 'pages#front'    
  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]
  
  get '/register', to: 'users#new'  
  resources :users, only: [:create, :show]   
  
  get '/people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  
  get '/home', to: 'videos#index'
  resources :videos, only: [:show, :index] do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end  
  
  resources :categories, only: [:show]  
    
  get 'ui(/:action)', controller: 'ui'
end
