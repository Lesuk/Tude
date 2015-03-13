class ArticlesController < ApplicationController
  #before_action :set_article, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:show]


  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

private
  
  def set_article
    #@article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  end

end
