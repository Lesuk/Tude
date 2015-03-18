class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def new
    @comment = @commentable.comments.build
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @commentable, success: "Comment added"}
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @commentable, success: "Can not create comment"}
        format.js
      end
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to @commentable, success: "Comment deleted"}
      format.js
    end
  end

private

  def comment_params
    params.require(:comment).permit(:body, :parent_id, :user_id, :commentable_id, :commentable_type)
  end

  def load_commentable
    klass = [Article].detect {|c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
