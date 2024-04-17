#2.1
class ProductsController < ApplicationController

  def index
    @products = Product.all
    
    if params[:on_sale]
      @products = @products.where(on_sale: true)
    end

    # Only show new products if 'recently_updated' param is not present
    if params[:new] && params[:recently_updated].blank?
      @products = @products.where('created_at >= ?', 3.days.ago)
    end

    # Only show recently updated products that are not new
    if params[:recently_updated]
      @products = @products.where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago)
    end

if params[:category_id].present?
  @products = @products.filter_by_category(params[:category_id])
end

if params[:keyword].present?
  @products = @products.search_by_keyword(params[:keyword])
end

@products = @products.page(params[:page]).per(8)

  end



  def show
    @product = Product.find(params[:id])
    @related_products = Product.where(category_id: @product.category_id).where.not(id: @product.id).limit(4)
  end

    
  end