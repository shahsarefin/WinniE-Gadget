class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def show
    
  end

  def new
    @order = Order.new
    @order_items = current_user.order_items
  end

  def create
    Order.transaction do
      @order = current_user.orders.build(order_params)
      @order.order_date = Time.now
      @order.status = "pending"
      
      current_cart.each do |product_id, quantity|
        product = Product.find(product_id)
        @order.order_items.build(product: product, quantity: quantity, price: product.price)
      end
      
      @order.save!
      session.delete(:cart) 
    end
    
    redirect_to @order, notice: 'Your order has been placed.'
  rescue => e
    flash[:error] = "There was a problem processing your order: #{e.message}"
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :address, :city, :province, :zipcode)
  end

  
  def set_order
    @order = Order.find(params[:id])
    
    redirect_to root_path, alert: "Access denied!" if @order.user != current_user
  end

  def confirm
    
    @order = current_user.orders.last
    if @order.present?
      @order.update(status: 'confirmed')
      
      redirect_to root_path, notice: 'Order confirmed successfully.'
    else
      redirect_to cart_path, alert: 'No order to confirm.'
    end
  end
end
