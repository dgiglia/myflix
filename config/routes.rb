Myflix::Application.routes.draw do  
  root to: 'pages#front'    
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  resources :users, only: [:create]    
  resources :videos, only: [:show, :index] do
    collection do
      get '/search', to: 'videos#search'
    end
  end  
  resources :categories, only: [:show]  
  get 'ui(/:action)', controller: 'ui'
end
