class UsersController < ApplicationController
  # TODO
  # after_action :record_user_view, only: [:show] # uncomment when root page will be changed

  def show
    @user = User.find_by_username(params[:id])
  end

  private

  def record_user_view
    View.set_view(@user, request.remote_ip)
  end
end
