class CategoriesController < ApplicationController
    
    def index
     
      if params[:id].present?
        
        redirect_to category_path(params[:id])
      else
        
        @categories = Category.all
        
      end
    end
  
   
    def show
      
      @category = Category.find(params[:id])
     
      @products = @category.products
      
    end
  end
  