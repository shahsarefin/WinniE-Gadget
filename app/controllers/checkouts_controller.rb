# app/controllers/checkouts_controller.rb
class CheckoutsController < ApplicationController
  def new
    if user_signed_in? && current_user.province.present?
      @province = current_user.province
    else
      @province = params[:province] || ''
    end

    @cart_items = current_cart.map do |product_id, quantity|
      product = Product.find(product_id)
      total_price = product.price * quantity
      { product: product, quantity: quantity, total_price: total_price }
    end

    @total_amount = @cart_items.sum { |item| item[:total_price] }
    @tax_rate = tax_rate_for_province(@province)
    @tax_amount = (@total_amount * @tax_rate).round(2)
    @total_with_tax = @total_amount + @tax_amount
  end

  private

  def tax_rate_for_province(province)
    tax_rates = {
      'Alberta' => 0.05,
      'British Columbia' => 0.12, # GST + PST
      'Manitoba' => 0.12, # GST + PST
      'New Brunswick' => 0.15, # HST
      'Newfoundland and Labrador' => 0.15, # HST
      'Northwest Territories' => 0.05,
      'Nova Scotia' => 0.15, # HST
      'Nunavut' => 0.05,
      'Ontario' => 0.13, # HST
      'Prince Edward Island' => 0.15, # HST
      'Quebec' => 0.14975, # GST + QST
      'Saskatchewan' => 0.11, # GST + PST
      'Yukon' => 0.05
    }

    tax_rates[province] || 0
  end
end
