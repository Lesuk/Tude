class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_article, only: [:favorite, :like] #[:edit, :update, :destroy]
  before_action :load_categories, only: [:index, :favorites, :popular, :recommended, :mine, :top]
  before_action :set_page_params, only: [:index, :favorites, :popular, :recommended, :mine, :top]
  before_action :set_page_size, only: [:index, :favorites, :popular, :recommended, :mine, :top]

  add_breadcrumb("Edut", '/')


  def index
    @articles = Article.includes(:category).published.in_category(params[:category_id]).order_desc.page(params[:page]).per(@page_size)
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
    @favorited = current_user.bookmarks?(@article)
    if @favorited
      current_user.unbookmark(@article)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.bookmark(@article)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def like
    @liked = current_user.likes?(@article)
    if @liked
      current_user.unlike(@article)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.like(@article)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def popular
    @articles = Article.includes(:category).published.in_category(params[:category_id]).order_popular.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def favorites
    @articles = current_user.bookmarked_articles.includes(:category).published.in_category(params[:category_id]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def recommended
    ids = current_user.recommended_articles.map{ |a| a.id }
    @articles = Article.includes(:category).in_array(ids).published.in_category(params[:category_id]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def top
    articles_array = Article.top_sorted_array(params[:category_id])
    @articles = Kaminari.paginate_array(articles_array).page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def mine
    @articles = current_user.articles.includes(:category).published.in_category(params[:category_id]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

private

  def find_article
    #@article = Article.friendly.find(params[:id])
    @article = Article.find(params[:id])
  end

  # def article_params
  #   params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  # end

  def load_categories
    @categories = Category.includes(:subcategories).main_categories
  end
  def set_page_params
    @page_params = params.slice(:pagesize, :category_id, :page, :view)
  end

  def set_page_size
    @page_size = params[:pagesize] ? params[:pagesize] : 8
  end

end
