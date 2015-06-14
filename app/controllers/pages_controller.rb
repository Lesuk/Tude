class PagesController < ApplicationController

  def landing
    redirect_to courses_path
  end

  def dashboard
    redirect_to feed_path
  end
end
