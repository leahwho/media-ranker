Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works
  
  resources :users, only: [:index, :show, :new, :create]
  
  get '/login', to: 'users#login_form', as: 'login'
  post '/login', to: 'users#login'
  post '/logout', to: 'users#logout', as: 'logout'
  get '/users/current', to: 'users#current', as: 'current_user'
end
