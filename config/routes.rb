Rails.application.routes.draw do
  get 'charges/new'
  get 'charges/create'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path: 'auth'

  get '/about', to: 'static#show', page_name: 'about'
  get '/contact', to: 'static#show', page_name: 'contact'

  root 'home#index'
  get 'products', to: 'products#index'
  resources :products, only: [:show]

  resources :categories, only: [:index, :show]

  resource :cart, only: [:show] do
    post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: :add_to_cart
    post 'update_cart_item/:product_id', to: 'carts#update_cart_item', as: 'update_item'
    delete 'remove_from_cart/:product_id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
  end

  resources :orders, only: [:new, :create, :show]
  resource :checkout, only: [:show, :create]

  delete '/users/sign_out', to: 'devise/sessions#destroy', as: :user_sign_out

  get 'profile', to: 'users#show', as: :user_profile

  post 'webhooks/stripe', to: 'webhooks#stripe'

  # Route for creating payment intent
  resources :checkouts, only: [] do
    post :create_payment_intent, on: :collection
  end
  resources :charges, only: [:new, :create]
  # Route for redirecting to payment form
  get '/checkout/payment', to: 'charges#new', as: 'new_payment_checkout'
  post '/checkout/payment/create_payment_intent', to: 'checkouts#create_payment_intent', as: 'create_payment_intent_checkout'

end
