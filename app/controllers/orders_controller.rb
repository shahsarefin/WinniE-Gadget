class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:create, :thank_you]

  before_action :set_order, only: [:show]


  def show
    
  end

  def new
    @order = Order.new
    
    @order_items = current_user.order_items
  end

  def create
    
    Order.transaction do
      
      # The association between the order and the user 
      @order = current_user.orders.build(order_params)
      @order.order_date = Time.now
      @order.status = "pending"
      
     
      current_cart.each do |product_id, quantity|
        product = Product.find(product_id)
        @order.order_items.build(product: product, quantity: quantity, price: product.price)
      end
      
      # Save the order, which also saves the associated address and order_items
      
      @order.save!
      # Clear the cart session after a successful order placement
      session.delete(:cart)
    end
    
  # Redirect to the thank you page instead of the order show page
  redirect_to thank_you_orders_path
rescue => e
  flash[:error] = "There was a problem processing your order: #{e.message}"
  render :new
end

  private

  #  the address is saved along with the order by using nested attributes
  def order_params
    params.require(:order).permit(:customer_id, address_attributes: [:street, :city, :province, :zipcode])
  end

  
  def set_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_path, alert: 'Order not found.'
    elsif @order.user != current_user
      redirect_to root_path, alert: 'Access denied!'
    end
  end

  # Confirm the last order for the current user
  def confirm
    @order = current_user.orders.last
    if @order.present?
      @order.update(status: 'confirmed')
      redirect_to root_path, notice: 'Order confirmed successfully.'
    else
      redirect_to cart_path, alert: 'No order to confirm.'
    end
  end

  
  def current_cart
    
  end

  def thank_you
    
  end
end
