class CoursesController < ApplicationController
  add_breadcrumb("Edut", '/')

  def index
    @courses = Course.includes(:category, :author).all
    add_breadcrumb("Курси", courses_path)
  end

  def show
    @course = Course.find(params[:id])
    add_breadcrumbs(["Courses", courses_path], [@course.category_name, category_path(@course.category)], [@course.title, nil])
  end
end
