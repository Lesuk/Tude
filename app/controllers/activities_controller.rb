class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb("Edut", '/')

  [:feed, :courses, :articles, :questions, :comments, :answers, :users].each do |action|
    define_method action do
      @activities = Activity.send("#{action}", current_user.id).includes(:owner, :trackable, :parent, :category)
      add_breadcrumb("Feed", nil)
      render :feed
    end
  end
end
