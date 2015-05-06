class UsersController < ApplicationController
  after_action :record_user_view, only: [:show]

  def show
    @user = User.find_by_username(params[:id])
  end

  private

  def record_user_view
    View.set_view(@user, request.remote_ip)
  end
end
