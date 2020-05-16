Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works do
    resources :votes # what routes do you need for votes? - for sure need post/create
  end
  
  # custom routes for user - don't move these!
  get '/users/current', to: 'users#current', as: 'current_user'
  get '/login', to: 'users#login_form', as: 'login'
  post '/login', to: 'users#login'
  post '/logout', to: 'users#logout', as: 'logout'
  
  resources :users, only: [:index, :show, :new, :create] do 
    resources :votes # what routes do you need for votes? only index?
  end
  
end
