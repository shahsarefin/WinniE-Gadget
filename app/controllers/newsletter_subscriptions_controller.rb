class NewsletterSubscriptionsController < ApplicationController
    def create
      
      flash[:notice] = "Thank you for subscribing!"
      redirect_to root_path
    end
  end
  