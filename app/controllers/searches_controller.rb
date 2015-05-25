class SearchesController < ApplicationController

  add_breadcrumb("Edut", '/')

  def courses
    search do
      Course.search_courses(params)
    end
  end

  def articles
    search do
      Article.search_articles(params)
    end
  end

  def questions
  end

 private

  def search(&block)
    if params[:q]
      load_categories
      set_course_levels
      set_page_params
      @search_results = yield if block_given?
    else
      @search_results = []
    end
    add_breadcrumb("Searching for #{params[:action]}", nil)
    render :search
  end

  def load_categories
    @categories ||= Category.includes(:subcategories).main_categories
  end

  def set_course_levels
    @levels = params[:action] == 'courses' ? Course::LEVELS : []
  end

  def set_page_params
    @page_params ||= params.slice(:q, :pagesize, :category, :level, :page, :view)
  end
end
