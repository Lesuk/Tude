class ArticleProgressesController < ApplicationController

  def create
    @article = Article.find(params[:article_progress][:article_id])
    current_user.pass_article!(@article.id)
    respond_to do |format|
      format.html { redirect_to @article }
      format.js
    end
  end

  def destroy
    @article = Article.find(params[:article_progress][:article_id])
    current_user.cancel_passed_article!(@article.id)
    respond_to do |format|
      format.html { redirect_to @article }
      format.js
    end
  end

end
