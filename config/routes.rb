Rails.application.routes.draw do
  
  root to: 'works#home'
  
  resources :works
  
  resources :users, only: [:index, :show, :new, :create]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
