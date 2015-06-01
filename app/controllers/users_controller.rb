class UsersController < ApplicationController
  after_action :record_user_view, only: [:show]

  add_breadcrumb("Edut", '/')

  def show
    @user = User.find_by_username(params[:id]) # leave it as instance variable
    activities = Activity.personal(@user.id).includes(:owner, :trackable, :parent, :category).order_desc.page(params[:page]).per(4)
    add_breadcrumbs(['Users', nil], [@user.name, nil])
    respond_to do |format|
      format.html {render :show, locals: {activities: activities}}
      format.js {render template: "activities/feed.js.erb", locals: {activities: activities}}
    end
  end

  def courses
    @user = User.find_by_username(params[:id])
    load_categories
    set_page_params
    levels = Course::LEVELS
    courses ||= @user.courses.includes(:category, :author).in_category(params[:category]).in_level(params[:level]).order_desc.page(params[:page]).per(set_page_size)
    add_breadcrumb("#{@user.name} courses", nil)
    render locals: {courses: courses, levels: levels}
  end

  def articles
    @user = User.find_by_username(params[:id])
    load_categories
    set_page_params
    articles = @user.articles.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(set_page_size)
    add_breadcrumb("#{@user.name} articles", nil)
    render locals: {articles: articles}
  end

  private

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
