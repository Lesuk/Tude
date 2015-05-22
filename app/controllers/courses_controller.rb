class CoursesController < ApplicationController
  before_action :authenticate_user!,
    only: [:curriculum, :continue_course, :favorite, :active, :completed, :favorites, :recommended, :mine]
  after_action :record_user_view, only: [:show]

  add_breadcrumb("Edut", '/')

  [:index, :active, :popular, :favorites, :recommended, :completed, :mine].each do |action|
    define_method action do
      @courses ||= method("load_#{action}_courses".to_sym).call
      add_breadcrumb("Courses", nil)
      render :index, locals: {courses: @courses}
    end
  end

  def show
    load_full_course
    check_enrollment
    user_progress
    add_breadcrumbs(["Courses", courses_path], [@course.category_name, category_path(@course.category)], [@course.title, nil])
    render locals: {course: @course, enrolled: @enrolled, user_progress: @user_progress}
  end

  def new
    build_course
  end

  def create
    build_course
    save_course(true) or render 'new'
  end

  def edit
  end

  def update
  end

  def destroy
    load_single_course
    @course.destroy
    redirect_to courses_url
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

  def favorite
    load_single_course
    @favorited = current_user.bookmarks?(@course)
    if @favorited
      current_user.unbookmark(@course)
      destroy_activity(current_user, 'favorited', @course)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.bookmark(@course)
      track_activity(current_user, 'favorited', @course)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

private

  def load_index_courses
    course_scope.includes(:category, :author)
  end

  def load_active_courses
    current_user.courses.merge(Enrollment.active).includes(:category, :author)
  end

  def load_completed_courses
    current_user.courses.merge(Enrollment.completed).includes(:category, :author)
  end

  def load_popular_courses
    course_scope.includes(:category, :author).order_popular.to_a
  end

  def load_favorites_courses
    current_user.bookmarked_courses.includes(:category, :author)
  end

  def load_recommended_courses
    current_user.recommended_courses.includes(:category, :author)
  end

  def load_mine_courses
    current_user.own_courses.includes(:category, :author)
  end

  def load_single_course
    @course ||= course_scope.friendly.find(params[:id])
  end

  def load_full_course
    @course ||= course_scope.includes({sections: :articles}, {reviews: :user}).friendly.find(params[:id])
  end

  def user_progress
    @user_progress ||= ( @course.articles.any? && @enrolled ) ? @course.user_progress(current_user) : {}
  end

  def check_enrollment
    @enrolled ||= current_user.try(:enrolled?, @course.id) if user_signed_in?
  end

  def build_course
    @course ||= course_scope.build
    @course.attributes = course_params
  end

  def save_course(track)
    if @course.save
      track_activity(@course, 'create') if track
      current_user.subscribe(@course)
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

  def record_user_view
    View.set_view(@course, request.remote_ip)
  end
end
