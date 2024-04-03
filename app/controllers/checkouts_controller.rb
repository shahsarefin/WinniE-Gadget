class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_items_and_total, only: [:show]
  before_action :set_stripe_api_key, only: [:create_payment_intent]

  def show
    if @total_price <= 0
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  def create_payment_intent
    # Check if cart is empty
    puts "@total_price: #{@total_price.inspect}" # Debugging statement
    redirect_to cart_path, alert: "Your cart is empty." and return if @total_price.nil? || @total_price <= 0
  
    # Fetch user's province
    user_province = current_user.address.province
  
    # Calculate taxes based on user's province
    taxes = user_province.calculate_taxes(@subtotal)
  
    # Calculate total price including taxes
    total_price_with_taxes = @subtotal + taxes
  
    # Create the payment intent
    payment_intent = Stripe::PaymentIntent.create(
      amount: (total_price_with_taxes * 100).to_i, # Stripe expects amount in cents
      currency: 'usd',
      metadata: { user_id: current_user.id }
    )
  
    # Redirect to Stripe's payment page, or send the client secret to your frontend
    # (Depending on your integration method, this may vary)
    respond_to do |format|
      format.json { render json: { clientSecret: payment_intent.client_secret } }
      format.html { redirect_to new_payment_checkout_path } # Redirect to payment form
    end
  rescue StandardError => e
    # Redirect to the payment form page if an error occurs
    redirect_to new_payment_checkout_path, alert: "An error occurred. Please try again."
  end

  private

  def set_cart_items_and_total
    @cart_items = current_cart_items
    @subtotal = calculate_total_price(@cart_items)
    @total_price = @subtotal || 0 # Assign 0 if @subtotal is nil
    puts "@total_price in set_cart_items_and_total: #{@total_price.inspect}" # Debugging statement
  end

  def calculate_total_price(cart_items)
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def set_stripe_api_key
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :sk_test_51Oys1NJCYOsLGkPMJzbSFV7jOXP9Ip3jDczYzXW9f7rPK0v7FPuBd86DVE92i76mEnd5SOExCGEyN8dFjuAqwGVT00022538eU)
  end
end
