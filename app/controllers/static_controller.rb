class StaticController < ApplicationController
    def show
      @content = Content.find_by(page_name: params[:page_name])
    end
end
  