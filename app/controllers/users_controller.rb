class UsersController < ApplicationController

  def show
    @user = User.includes(:articles).find_by_username(params[:id])
  end

end
