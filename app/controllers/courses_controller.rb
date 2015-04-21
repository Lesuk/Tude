class CoursesController < ApplicationController
  add_breadcrumb("Edut", '/')

  def index
    courses = Course.includes(:category, :author).all.to_a
    add_breadcrumb("Курси", nil)
    render locals: {courses: courses}
  end

  def show
    course = Course.includes({sections: :articles}).find(params[:id])
    add_breadcrumbs(["Courses", courses_path], [course.category_name, category_path(course.category)], [course.title, nil])
    render locals: {course: course}
  end
end
