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
    unless province_selected?
      redirect_to select_province_checkouts_path and return
    end
  
  
    province_name = if user_signed_in? && current_user.address&.province
                      current_user.address.province.name
                    else
                      session[:province]
                    end
  
    # Normalize province name to match keys in calculate_tax method
    province_name = province_name.strip.titleize
    
    @tax_amount = calculate_tax(@total_amount, province_name)
    @total_with_tax = @total_amount + @tax_amount
  end

  def create
    # Placeholder for order processing logic. After saving the order, the cart is cleared.
    session[:cart] = nil
    session.delete(:province) # Ensure we also clear the province from the session
    redirect_to thank_you_orders_path, notice: 'Thank you for your order!'
  end

  # def create
  #   # Placeholder for order processing logic. After saving the order, the cart is cleared.
  #   session[:cart] = nil
  #   redirect_to thank_you_orders_path, notice: 'Thank you for your order!'
  # end

  private

  def set_cart_items_and_total
    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      total_price = product.price * quantity
      { product: product, quantity: quantity, total_price: total_price }
    end

    @total_amount = @cart_items.sum { |item| item[:total_price] }
  end

  # def set_cart_items_and_total
  #   @cart_items = current_cart.map do |product_id, quantity|
  #     product = Product.find(product_id)
  #     total_price = product.price * quantity
  #     { product: product, quantity: quantity, total_price: total_price }
  #   end

  #   @total_amount = @cart_items.sum { |item| item[:total_price] }
  #   province = find_province
  #   @tax_amount = province ? province.calculate_taxes(@total_amount) : 0
  #   @total_with_tax = @total_amount + @tax_amount
  # end

  def calculate_tax(amount, province_name)
    # Define tax rates for all provinces and territories in Canada
    tax_rates = {
      'Alberta' => { gst: 0.05, pst: 0.0, hst: 0.0 },
      'British Columbia' => { gst: 0.05, pst: 0.07, hst: 0.0 },
      'Manitoba' => { gst: 0.05, pst: 0.07, hst: 0.0 },
      'New Brunswick' => { gst: 0.0, pst: 0.0, hst: 0.15 },
      'Newfoundland and Labrador' => { gst: 0.0, pst: 0.0, hst: 0.15 },
      'Northwest Territories' => { gst: 0.05, pst: 0.0, hst: 0.0 },
      'Nova Scotia' => { gst: 0.0, pst: 0.0, hst: 0.15 },
      'Nunavut' => { gst: 0.05, pst: 0.0, hst: 0.0 },
      'Ontario' => { gst: 0.0, pst: 0.0, hst: 0.13 },
      'Prince Edward Island' => { gst: 0.0, pst: 0.0, hst: 0.15 },
      'Quebec' => { gst: 0.05, pst: 0.09975, hst: 0.0 },  # PST in Quebec is represented as a decimal
      'Saskatchewan' => { gst: 0.05, pst: 0.06, hst: 0.0 },
      'Yukon' => { gst: 0.05, pst: 0.0, hst: 0.0 }
    }
    
    rates = tax_rates[province_name]
    tax = 0.0
    tax += amount * rates[:gst] if rates && rates[:gst]
    tax += amount * rates[:pst] if rates && rates[:pst]
    tax += amount * rates[:hst] if rates && rates[:hst]
    tax
  end
  

  def province_selected?
    user_signed_in? && current_user.address&.province.present? || session[:province].present?
  end

  def find_province
    if user_signed_in? && current_user.address&.province
      current_user.address.province
    else
      Province.find_by(name: session[:province])
    end
  end
end
