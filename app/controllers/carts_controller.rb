class CartsController < ApplicationController
  before_action :set_product, only: [:add_to_cart]

  def show
    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      total_price = product.price * quantity
      { product: product, quantity: quantity, total_price: total_price }
    end
    @total_amount = @cart_items.sum { |item| item[:total_price] }
  end

  
  def add_to_cart
    id = @product.id.to_s
    current_cart[id] = current_cart.fetch(id, 0) + 1
    session[:cart] = current_cart
    redirect_to products_path, notice: 'Product added to cart'
  end

  def update_cart_item
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      current_cart[product_id] = quantity
    else
      current_cart.delete(product_id)
    end

    session[:cart] = current_cart
    redirect_to cart_path
  end

  def remove_from_cart
    current_cart.delete(params[:product_id].to_s)
    session[:cart] = current_cart
    redirect_to cart_path, notice: 'Item removed from cart'
  end

  def clear_cart
    session[:cart] = {}
    redirect_to thank_you_orders_path, notice: 'Thank you for your order! Your cart has been cleared.'
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Product not found'
  end
end