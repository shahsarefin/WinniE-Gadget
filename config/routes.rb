Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users


  get '/about', to: 'static#show', page_name: 'about'
  get '/contact', to: 'static#show', page_name: 'contact'

  root 'home#index'
  get 'products', to: 'products#index'
  resources :products, only: [:show]
  
resources :categories, only: [:index, :show]

resources :carts, only: [:index, :create, :update, :destroy]

end 
