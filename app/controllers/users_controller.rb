
class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def show
      @user = current_user
      @address = @user.address
      @province = @address.province if @address.present?
    end
  end
  