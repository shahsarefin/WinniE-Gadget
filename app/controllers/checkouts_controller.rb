class CheckoutsController < ApplicationController
  def new
    # Check if there's a province in the session first
    province_from_session = session[:province]

    @province_name = if user_signed_in? && current_user.address
                       current_user.address.province.try(:name)
                     elsif province_from_session
                       province_from_session
                     else
                       'Enter Your Province'
                     end

    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      total_price = product.price * quantity
      { product: product, quantity: quantity, total_price: total_price }
    end

    @total_amount = @cart_items.sum { |item| item[:total_price] }
    @tax_components = calculate_tax_components(@province_name, @total_amount)
    @total_with_tax = @total_amount + @tax_components.values.sum
  end

  def submit_province
    # Logic to handle the province submission.
    # For example, set the submitted province in a session or instance variable.
    session[:province] = params[:province]

    # Redirect back to the 'new' action or render 'new' directly with the updated information
    redirect_to new_checkout_path
  end

  def place_order
    # Code to handle order placement...
    # This section would need your actual order placement logic
    redirect_to thank_you_path
  end
  
  private

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
