class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def feed
    @activities = Activity.articles(current_user.id).includes(:owner, :trackable, :parent, :category)
  end
end
