Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works
  get '/users/current', to: 'users#current', as: 'current_user'
  get '/login', to: 'users#login_form', as: 'login'
  post '/login', to: 'users#login'
  post '/logout', to: 'users#logout', as: 'logout'

  resources :users, only: [:index, :show, :new, :create]
  
  
  
end
