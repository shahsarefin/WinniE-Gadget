class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = current_cart_items
    @subtotal = calculate_total_price(@cart_items)
    
    user_province = current_user.address&.province
    
    if user_province
      gst_rate = user_province.gst_rate || 0
      pst_rate = user_province.pst_rate || 0
      hst_rate = user_province.hst_rate || 0

      @gst = gst_rate * @subtotal / 100.0
      @pst = pst_rate * @subtotal / 100.0
      @hst = hst_rate * @subtotal / 100.0

      if hst_rate > 0
        @gst = 0
        @pst = 0
      end

      @total_price = @subtotal + @gst + @pst + @hst
    else
      redirect_to some_path_to_add_or_edit_address, notice: 'Please complete your shipping address information.'
      return
    end
    
    @order = current_user.orders.build
  end
  

  
  

  def create
    @order = current_user.orders.build(order_params)

    if @order.save
      add_cart_items_to_order(@order)
      @order.calculate_total_with_taxes
      clear_cart
      redirect_to order_path(@order), notice: 'Order placed successfully.'
    else
      flash.now[:alert] = 'Error occurred while processing your order.'
      render :show
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_name,
      address_attributes: [:street, :city, :province_id]
    )
  end

  def calculate_total_price(cart_items)
    cart_items.sum { |item| item.product.price * item.quantity }
  end
  
  
end
