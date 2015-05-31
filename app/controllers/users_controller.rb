class UsersController < ApplicationController
  after_action :record_user_view, only: [:show]

  add_breadcrumb("Edut", '/')

  def show
    @user = User.find_by_username(params[:id])
    add_breadcrumb(@user.name, nil)
    render locals: {user: @user}
  end

  def activity
    @user = User.find_by_username(params[:id])
    add_breadcrumb("#{@user.name} activity", nil)
    render locals: {user: @user}
  end

  def courses
    load_categories
    set_page_params
    levels = Course::LEVELS
    @user = User.find_by_username(params[:id])
    @courses ||= @user.own_courses.includes(:category, :author).in_category(params[:category]).in_level(params[:level]).order_desc.page(params[:page]).per(set_page_size)
    add_breadcrumb("#{@user.name} courses", nil)
    render locals: {courses: @courses, levels: levels}
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
