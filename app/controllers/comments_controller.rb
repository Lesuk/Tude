class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    load_commentable
    build_comment
  end

  def create
    load_commentable
    build_comment
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @commentable, success: 'Comment added' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @commentable, success: 'Can not create comment' }
        format.js
      end
    end
  end

  def update
    load_commentable
    load_comment
    respond_to do |format|
      @comment.update_attributes(comment_params)
      format.json { respond_with_bip(@comment) }
    end
  end

  def destroy
    load_commentable
    load_comment
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @commentable, success: 'Comment deleted' }
      format.js
    end
  end

  def upvote
    load_single_comment
    @upvoted = current_user.likes?(@comment)
    if @upvoted
      current_user.unlike(@comment)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.like(@comment)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def downvote
    load_single_comment
    @downvoted = current_user.dislikes?(@comment)
    if @downvoted
      current_user.undislike(@comment)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.dislike(@comment)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

private

  def load_commentable
    klass = [Article].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def load_comment
    @comment ||= comment_scope.find(params[:id])
  end

  def load_single_comment
    @comment ||= Comment.find(params[:id])
  end

  def build_comment
    @comment ||= comment_scope.build
    @comment.attributes = comment_params
  end

  def comment_params
    comment_params = params[:comment]
    comment_params ? comment_params.permit(:body, :parent_id, :subparent_id, :user_id, :commentable_id, :commentable_type) : {}
    #params.require(:comment).permit(:body, :parent_id, :user_id, :commentable_id, :commentable_type)
  end

  def comment_scope
    @commentable.comments.where(nil)
  end
end
