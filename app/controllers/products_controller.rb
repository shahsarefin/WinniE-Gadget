#2.1
class ProductsController < ApplicationController
    def index
      @products = Product.all
    end
  end