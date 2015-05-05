class CoursesController < ApplicationController
  before_action :authenticate_user!, only: [:curriculum, :continue_course]

  add_breadcrumb("Edut", '/')

  def index
    load_courses
    add_breadcrumb("Courses", nil)
    render locals: {courses: @courses}
  end

  def show
    load_full_course
    check_enrollment
    course_passed_articles_ids
    add_breadcrumbs(["Courses", courses_path], [@course.category_name, category_path(@course.category)], [@course.title, nil])
    render locals: {course: @course, enrolled: @enrolled}
  end

  def curriculum
    load_single_course
    @articles = @course.different_articles
    add_breadcrumbs(["Courses", courses_path], [@course.category_name, category_path(@course.category)], [@course.title, course_path(@course)], ['Curriculum', nil])
  end

  def continue_course
    load_single_course
    article = @course.continue_course_article(current_user)
    redirect_to article_path(article)
  end

private

  def load_courses
    @courses ||= course_scope.includes(:category, :author).to_a
  end

  def load_single_course
    @course ||= course_scope.friendly.find(params[:id])
  end

  def load_full_course
    @course ||= course_scope.includes({sections: :articles}, {reviews: :user}).friendly.find(params[:id])
  end

  def course_passed_articles_ids
    @passed_ids ||= (user_signed_in? && @course.articles.any? && @enrolled) ? @course.user_progress(current_user, "passed") : []
  end

  def check_enrollment
    @enrolled ||= current_user.try(:enrolled?, @course.id) if user_signed_in?
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
