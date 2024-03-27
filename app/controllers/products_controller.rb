#2.1
class ProductsController < ApplicationController

  def index
    @products = Product.all

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:keyword].present?
      @products = @products.search_by_keyword(params[:keyword])
    end

    @products = @products.page(params[:page]).per(8) # Assuming pagination
  end



    def show
      @product = Product.find(params[:id])
    end

    
  end