# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @on_sale_products = Product.on_sale
    @new_products = Product.new_products
    @recently_updated_products = Product.recently_updated
  end
end
