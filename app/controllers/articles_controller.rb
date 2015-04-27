class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:recommended, :favorites, :mine, :favorite, :like]

  add_breadcrumb("Edut", '/')

  def index
    load_categories
    set_page_params
    set_page_size
    @articles = Article.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
  end

  def show
    load_article_with_categories
    load_course_articles
    set_commentable
    load_comments
    ArticleView.set_view(@article.id, request.remote_ip)
    add_breadcrumbs(["Articles", articles_path], [@article.category_name, category_path(@article.category)], [@article.title, nil])
  end

  def popular
    load_categories
    set_page_params
    set_page_size
    @articles = Article.includes(:category).published.in_category(params[:category]).order_popular.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def favorites
    load_categories
    set_page_params
    set_page_size
    @articles = current_user.bookmarked_articles.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def recommended
    load_categories
    set_page_params
    set_page_size
    ids = current_user.recommended_articles.map{ |a| a.id }
    @articles = Article.includes(:category).in_array(ids).published.in_category(params[:category]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def top
    load_categories
    set_page_params
    set_page_size
    articles_array = Article.top_sorted_array(params[:category])
    @articles = Kaminari.paginate_array(articles_array).page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def mine
    load_categories
    set_page_params
    set_page_size
    @articles = current_user.articles.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(@page_size)
    add_breadcrumb("Articles", nil)
    render :index
  end

  def favorite
    load_article
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
    load_article
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

  def sort
    params[:article].each_with_index do |id, index|
      Article.where(id: id).update_all({position: index+1})
    end
    render nothing: true
  end

private

  def load_articles
    @articles ||= article_scope.to_a
  end

  def load_article
    @article ||= article_scope.friendly.find(params[:id])
  end

  def load_article_with_categories
    @article ||= article_scope.includes(:category).friendly.find(params[:id])
  end

  def load_categories
    @categories ||= Category.includes(:subcategories).main_categories
  end

  def load_course_articles
    @course_articles ||= @article.course.articles if @article.course
  end

  def load_comments
    @comments = @commentable.comments.includes(:user, {subcomments: :user}).main_comments
  end

  def set_commentable
    @commentable ||= @article
  end

  def set_page_params
    @page_params ||= params.slice(:pagesize, :category, :page, :view)
  end

  def set_page_size
    @page_size ||= params[:pagesize] ? params[:pagesize] : 8
  end

  def article_params
    article_params = params[:article]
    article_params ? article_params.permit(:title, :description, :body, :status, :slug, :category_id, :course_id) : {}
    #params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  end

  def article_scope
    Article.where(nil)
  end

end
