# app/controllers/charges_controller.rb

class ChargesController < ApplicationController
  def new
  end

  def create
    # Get the token from the params
    token = params[:stripeToken]

    # Make the charge using the token
    charge = Stripe::Charge.create(
      amount: calculate_amount(params[:amount]), # Convert amount to cents
      currency: 'usd',
      source: token,
      description: 'Payment Description' # You can customize this
    )

    # Handle successful payment (e.g., update database, send confirmation email, etc.)
    # Redirect the user to a success page or render a success message
    redirect_to root_path, notice: 'Payment successful!'
  rescue Stripe::CardError => e
    # Handle card error (e.g., display error message to the user)
    redirect_to new_charge_path, alert: e.message
  rescue StandardError => e
    # Handle other errors
    redirect_to new_charge_path, alert: 'An error occurred. Please try again later.'
  end

  private

  def calculate_amount(amount)
    # Convert amount to cents or perform any necessary calculation
    # For example: amount.to_i * 100
  end
end