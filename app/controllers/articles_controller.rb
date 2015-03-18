class ArticlesController < ApplicationController
  #before_action :set_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  add_breadcrumb("Edut", '/')


  def index
    @articles = Article.includes(:category).published
    @articles = @articles.popular if params[:sort] == 'popularity'
    @articles = current_user.favorite_articles.published if params[:sort] == 'favorited'
    @articles = @articles.order_desc

    @categories = Category.includes(:subcategories).main_categories

    add_breadcrumb("Публікації", articles_path)
  end

  def show
    @article = Article.find(params[:id])
    @commentable = @article
    @comments = @commentable.comments.includes(:user, {subcomments: :user}).main_comments
    
    @article.article_views.find_or_create_by!(guest_ip: request.remote_ip)

    add_breadcrumbs([@article.category.name, category_path(@article.category)], [@article.title, nil])
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

private
  
  def set_article
    #@article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  end

end
