class UsersController < ApplicationController
  after_action :record_user_view, only: [:show]

  add_breadcrumb("Edut", '/')

  def show
    load_user
    activities = Activity.personal(@user.id).includes(:owner, :trackable, :parent, :category).order_desc.page(params[:page]).per(10)
    add_breadcrumbs(['Users', nil], [@user.name, nil])
    respond_to do |format|
      format.html {render :show, locals: {activities: activities}}
      format.js {render template: "activities/feed.js.erb", locals: {activities: activities}}
    end
  end

  def courses
    load_user
    load_categories
    set_page_params
    levels = Course::LEVELS
    courses ||= @user.courses.includes(:category, :author).in_category(params[:category]).in_level(params[:level]).order_desc.page(params[:page]).per(set_page_size)
    add_breadcrumb("#{@user.name} courses", nil)
    render locals: {courses: courses, levels: levels}
  end

  def articles
    load_user
    load_categories
    set_page_params
    articles = @user.articles.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(set_page_size)
    add_breadcrumb("#{@user.name} articles", nil)
    render locals: {articles: articles}
  end

  def questions
    load_user
    add_breadcrumb("#{@user.name} questions", nil)
  end

  def answers
    load_user
    add_breadcrumb("#{@user.name} answers", nil)
  end

  def comments
    load_user
    comments = @user.comments.includes(:user, :commentable) # {subcomments: :user}
    add_breadcrumb("#{@user.name} comments", nil)
    render locals: {comments: comments}
  end

  def reviews
    load_user
    reviews = @user.reviews.includes(:user, :course)
    add_breadcrumb("#{@user.name} reviews", nil)
    render locals: {reviews: reviews}
  end

 private

  def load_user
    @user = User.find_by_username(params[:id])
  end

  def record_user_view
    View.set_view(@user, request.remote_ip)
  end

  def load_categories
    @categories ||= Category.includes(:subcategories).main_categories
  end

  def set_page_params
    @page_params ||= params.slice(:pagesize, :category, :level, :page, :view)
  end

  def set_page_size
    params[:pagesize] ? params[:pagesize] : 8
  end
end
