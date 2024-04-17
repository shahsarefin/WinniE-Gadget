Rails.application.routes.draw do
  get 'charges/new'
  get 'charges/create'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path: 'auth'

  # get '/about', to: 'static#show', page_name: 'about'
  get 'about', to: 'static#about'
  # get '/contact', to: 'static#show', page_name: 'contact'
  get 'contact', to: 'static#contact'


  root 'home#index'
  get 'products', to: 'products#index'
  resources :products, only: [:show]

  resources :categories, only: [:index, :show]

  resource :cart, only: [:show] do
    post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: :add_to_cart
    post 'update_cart_item/:product_id', to: 'carts#update_cart_item', as: 'update_item'
    delete 'remove_from_cart/:product_id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
  end
  
  get 'orders/thank_you', to: 'orders#thank_you', as: :thank_you_orders
  resources :orders, only: [:new, :create, :show]
  resources :checkouts, only: [:new, :create] do
    collection do
      post :submit_province
    end
  end

  delete '/users/sign_out', to: 'devise/sessions#destroy', as: :user_sign_out

  get 'profile', to: 'users#show', as: :user_profile

  post 'webhooks/stripe', to: 'webhooks#stripe'
  post 'checkouts/place_order', to: 'checkouts#place_order', as: :place_order_checkouts



end