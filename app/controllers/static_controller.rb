class StaticController < ApplicationController
  def show
    @content = Content.find_by(page_name: params[:page_name])
    unless @content
      # Handle case where content for the given page name is not found
      render plain: "Page not found", status: :not_found
    end
  end
end
