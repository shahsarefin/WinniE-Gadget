#2.1
class ProductsController < ApplicationController

  def index
    @products = Product.all.page(params[:page]).per(8) # Kaminari pagination applied here
    # Apply filters if any parameters are present
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.search_by_keyword(params[:keyword]) if params[:keyword].present?
  end



    def show
      @product = Product.find(params[:id])
    end

    
  end