class StaticController < ApplicationController
  def show
    @content = Content.find_by(page_name: params[:page_name])
    unless @content
      
      render plain: "Page not found", status: :not_found
    end
  end
end
