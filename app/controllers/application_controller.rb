class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  include FlashHelper

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :username, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  # Redirect to a specific page on successful sign in
  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_out_path_for(resource)
    stored_location_for(resource) || request.referer || root_path
  end

private

  def track_activity(trackable, key = params[:action], parent = nil, recipient = nil)
    a = current_user.activities.new
    a.trackable = trackable
    a.parent = parent if parent
    a.category_id = trackable.category_id if trackable.try(:category_id)
    a.key = key
    a.recipient_id = recipient if recipient
    a.save
  end

  def destroy_activity(trackable, key, parent)
    activity = Activity.where(trackable: trackable, owner_id: current_user.id, key: key, parent: parent).first
    activity.destroy if activity
  end

end
