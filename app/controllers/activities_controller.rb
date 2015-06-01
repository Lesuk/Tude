class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb("Edut", '/')

  [:feed, :courses, :articles, :questions, :comments, :answers, :users, :personal].each do |action|
    define_method action do
      # group("year(created_at)").group("month(created_at)")
      @activities = Activity.send("#{action}", current_user.id).includes(:owner, :trackable, :parent, :category).order_desc.page(params[:page]).per(10)
      add_breadcrumb("Activities", nil)
      respond_to do |format|
        format.html {render :feed}
        format.js {render :feed}
      end
    end
  end
end
