class PagesController < ApplicationController

  def landing
    redirect_to courses_path
  end
end
