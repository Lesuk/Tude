class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  #before_action :set_article, only: [:edit, :update, :destroy]
  before_action :load_categories, only: [:index, :favorites, :popular]
  before_action :set_page_params, only: [:index, :favorites, :popular]

  add_breadcrumb("Edut", '/')


  def index
    page_size = params[:pagesize] ? params[:pagesize] : 8
    @articles = Article.includes(:category).published.in_category(params[:category_id]).order_desc.page(params[:page]).per(page_size)
    add_breadcrumb("Articles", nil)
    #render locals: {}
  end

  def show
    @article = Article.includes(:course).find(params[:id])
    @commentable = @article
    @articles = @article.course.articles if @article.course

    @comments = @commentable.comments.includes(:user, {subcomments: :user}).main_comments # .order(sort_order)

    @article.article_views.find_or_create_by!(guest_ip: request.remote_ip)

    add_breadcrumbs(["Articles", articles_path], [@article.category_name, category_path(@article.category)], [@article.title, nil])
  end

  def favorite
    article = Article.find(params[:id])
    @favorite_present = article.user_fan?(current_user.id)
    if @favorite_present
      current_user.favorite_articles.delete(article)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.favorite_articles << article
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def popular
    page_size = params[:pagesize] ? params[:pagesize] : 8
    @articles = Article.includes(:category).published.in_category(params[:category_id]).order_popular.page(params[:page]).per(page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def favorites
    page_size = params[:pagesize] ? params[:pagesize] : 8
    @articles = Article.includes(:category).published.in_category(params[:category_id]).order_popular.page(params[:page]).per(page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

private

  # def set_article
  #   @article = Article.friendly.find(params[:id])
  # end

  # def article_params
  #   params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  # end

  def load_categories
    @categories = Category.includes(:subcategories).main_categories
  end
  def set_page_params
    @page_params = params.slice(:pagesize, :category_id, :page, :view)
  end

end
