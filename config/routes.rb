Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works do
    resources :votes, only: [:create]
  end
  
  get '/users/current', to: 'users#current', as: 'current_user'
  get '/login', to: 'users#login_form', as: 'login'
  post '/login', to: 'users#login'
  post '/logout', to: 'users#logout', as: 'logout'

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  
  resources :users, only: [:index, :show, :new, :create] do 
    resources :votes, only: [:create]
  end
  
end
