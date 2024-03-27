class ApplicationController < ActionController::Base
  helper_method :current_cart, :current_cart_items
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  private
  
  def current_cart
    session[:cart] ||= {}
  end

  def current_cart_items
    current_cart.map do |product_id, quantity|
      product = Product.find_by_id(product_id)
      next unless product
      total_price = product.price * quantity
      OpenStruct.new(product: product, quantity: quantity, total_price: total_price)
    end.compact
  end
  
  protected
  
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        :name, :email, :password, :password_confirmation,
        address_attributes: [:street, :city, :province_id]
      ])
  end
end
