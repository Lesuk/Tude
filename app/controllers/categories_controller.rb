class CategoriesController < ApplicationController

  add_breadcrumb("Edut", '/')

  def index
  end

  def show
    category ||= load_category
    set_page_params
    levels = Course::LEVELS
    courses ||= load_courses(category)
    add_breadcrumbs(["Categories", categories_path], [category.name, nil])
    render locals: {category: category, courses: courses, levels: levels}
  end

  def articles
    category ||= load_category
    set_page_params
    articles ||= load_articles(category)
    add_breadcrumbs(["Categories", categories_path], [category.name, category_path(category)], ["Articles", nil])
    render locals: {category: category, articles: articles}
  end

  def questions
    category ||= load_category
    set_page_params
    # questions ||= load_questions(category)
    add_breadcrumbs(["Categories", categories_path], [category.name, category_path(category)], ["Questions", nil])
    render locals: {category: category}
  end

  def quizzes
    category ||= load_category
    quizzes ||= load_quizzes(category)
    add_breadcrumbs(["Categories", categories_path], [category.name, category_path(category)], ["Quizzes", nil])
    render locals: {category: category, quizzes: quizzes}
  end

  private

  def load_category
    Category.friendly.find(params[:id])
  end

  def load_courses(category)
    Course.includes(:category, :author).in_category(category.to_param).in_level(params[:level]).order_desc.page(params[:page]).per(set_page_size)
  end

  def load_articles(category)
    Article.includes(:category).published.in_category(category.to_param).order_desc.page(params[:page]).per(set_page_size)
  end

  def load_quizzes(category)
    Quiz.includes(:category).active.in_category(category.to_param).order_desc
  end

  def set_page_params
    @page_params ||= params.slice(:pagesize, :category, :level, :page, :view)
  end

  def set_page_size
    params[:pagesize] ? params[:pagesize] : 8
  end
end
