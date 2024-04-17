class CheckoutsController < ApplicationController
  before_action :set_cart_items_and_total, only: [:new]

  def select_province
    # Redirects to checkout if a province is already set
    redirect_to new_checkout_path if province_selected?
  end

  def submit_province
    # Saves the selected province in the session and redirects to the checkout page
    session[:province] = params[:province]
    redirect_to new_checkout_path
  end

  def new
    # Shows the checkout page with cart items and total cost including taxes
  end

  def create
    # Placeholder for order processing logic. After saving the order, the cart is cleared.
    session[:cart] = nil
    redirect_to thank_you_orders_path, notice: 'Thank you for your order!'
  end

  private

  def set_cart_items_and_total
    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      total_price = product.price * quantity
      { product: product, quantity: quantity, total_price: total_price }
    end

    @total_amount = @cart_items.sum { |item| item[:total_price] }
    province = find_province
    @tax_amount = province ? province.calculate_taxes(@total_amount) : 0
    @total_with_tax = @total_amount + @tax_amount
  end

  def province_selected?
    user_signed_in? && current_user.address&.province.present? || session[:province].present?
  end

  def find_province
    if user_signed_in? && current_user.address&.province
      current_user.address.province
    elsif session[:province]
      Province.find_by(id: session[:province])
    end
  end
end
