class CoursesController < ApplicationController
  add_breadcrumb("Edut", '/')

  def index
    load_courses
    add_breadcrumb("Курси", nil)
    render locals: {courses: @courses}
  end

  def show
    load_course
    add_breadcrumbs(["Courses", courses_path], [@course.category_name, category_path(@course.category)], [@course.title, nil])
    render locals: {course: @course}
  end

private

  def load_courses
    @courses ||= course_scope.includes(:category, :author).to_a
  end

  def load_course
    @course ||= course_scope.includes({sections: :articles}).find(params[:id])
  end

  def build_course
    @course ||= course_scope.build
    @course.attributes = course_params
  end

  def save_course
    if @course.save
      redirect_to @course
    end
  end

  def course_params
    course_params = params[:course]
    course_params ? course_params.permit(:title, :summary, :description, :slug, :content, :level, :duration, :youtube_id, :category_id) : {}
  end

  def course_scope
    Course.where(nil)
  end
end
