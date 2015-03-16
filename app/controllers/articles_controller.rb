class ArticlesController < ApplicationController
  #before_action :set_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @articles = Article.includes(:category).all
    @categories = Category.includes(:subcategories).main_categories
  end

  def show
    @article = Article.find(params[:id])
    @article.article_views.find_or_create_by!(guest_ip: request.remote_ip)
  end

private
  
  def set_article
    #@article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  end

end
