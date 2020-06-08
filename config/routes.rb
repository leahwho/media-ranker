Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works do
    resources :votes, only: [:create]
  end
  
  get '/users/current', to: 'users#current', as: 'current_user'

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"
  
  resources :users, only: [:index, :show, :new, :create] do 
    resources :votes, only: [:create]
  end
  
end
