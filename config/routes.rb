Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users


  get '/about', to: 'static#show', page_name: 'about'
  get '/contact', to: 'static#show', page_name: 'contact'

  get '/products', to: 'products#index', as: 'products'
  get '/products/:id', to: 'products#show', as: 'product'

  root 'home#index'

end
