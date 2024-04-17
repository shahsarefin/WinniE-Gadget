class CheckoutsController < ApplicationController
  before_action :set_province_name, only: [:new]

  def select_province
    if user_signed_in? && current_user.address&.province.present? || session[:province].present?
      redirect_to new_checkout_path
    else
      # If this branch is executed, it implies the view `select_province.html.erb` should be rendered.
      # Make sure the view exists at app/views/checkouts/select_province.html.erb
    end
  end

  def submit_province
    # Store the selected province in the session and redirect to the new checkout page
    session[:province] = params[:province]
    redirect_to new_checkout_path
  end

  def new
    # Setup for the new checkout page, including calculating taxes based on the province
    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      total_price = product.price * quantity
      { product: product, quantity: quantity, total_price: total_price }
    end

    @total_amount = @cart_items.sum { |item| item[:total_price] }
    @tax_components = calculate_tax_components(@province_name, @total_amount)
    @total_with_tax = @total_amount + @tax_components.values.sum
  end

  def place_order
    # Placeholder for the logic to place an order
    redirect_to thank_you_orders_path
  end
  
  private

  def set_province_name
    if user_signed_in? && current_user.address&.province.present?
      @province_name = current_user.address.province.name
    elsif session[:province].present?
      # Assuming Province is your model name and it has a `name` attribute
      province = Province.find_by(id: session[:province])
      @province_name = province&.name || 'Enter Your Province'
    else
      @province_name = 'Enter Your Province'
    end
  end
  
  

  def calculate_tax_components(province_name, total)
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
      'Quebec' => { gst: 0.05, pst: 0.09975, hst: 0.0 },
      'Saskatchewan' => { gst: 0.05, pst: 0.06, hst: 0.0 },
      'Yukon' => { gst: 0.05, pst: 0.0, hst: 0.0 }
    }

    rates = tax_rates[province_name] || { gst: 0.0, pst: 0.0, hst: 0.0 }
    {
      gst: (total * rates[:gst]).round(2),
      pst: (total * rates[:pst]).round(2),
      hst: (total * rates[:hst]).round(2)
    }
  end

  def thank_you_path
    
    
  end
end
