Rails.application.routes.draw do
  
  root 'home#index'
  
  
  devise_for :users, path: 'auth'

  # Routes for products
  resources :products, only: [:index, :show]

  # Routes for categories
  resources :categories, only: [:index, :show]

  # Singular resource for cart showing a collection of items
  resource :cart, only: [:show] do
    post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: :add_to_cart
    post 'update_cart_item/:product_id', to: 'carts#update_cart_item', as: :update_item
    delete 'remove_from_cart/:product_id', to: 'carts#remove_from_cart', as: :remove_from_cart
    delete 'clear', to: 'carts#clear_cart', as: :clear_cart
  end

  # Checkout process routes
  resources :checkouts, only: [:new, :create] do
    collection do
      get :select_province  # For selecting province if necessary
      post :submit_province # For submitting selected province
    end
  end

  # Thank you page route after order placement
  get 'orders/thank_you', to: 'orders#thank_you', as: :thank_you_orders

  
  post 'newsletter_subscriptions', to: 'newsletter_subscriptions#create'

  
  post 'webhooks/stripe', to: 'webhooks#stripe'

  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  
  get 'about', to: 'static#about'

 
  get 'contact', to: 'static#contact'
  
  
  get 'profile', to: 'users#show', as: :user_profile

  
  resources :orders, only: [:index, :show, :create, :new]
end
