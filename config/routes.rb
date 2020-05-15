Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works
  
  resources :users, only: [:index, :show, :new, :create]
  
  
end
