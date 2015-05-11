class PagesController < ApplicationController
  def feed
    @activities = Activity.includes(:owner, :trackable, :course, :category)
  end
end
