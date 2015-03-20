class CoursesController < ApplicationController
  add_breadcrumb("Edut", '/')

  def index
    @courses = Course.includes(:category, :author).all
    add_breadcrumb("Курси", courses_path)
  end

  def show
  end
end
