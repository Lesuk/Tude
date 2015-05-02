class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    load_course
    build_review
  end

  def create
    load_course
    build_review
    @review.user_id = current_user.id
    if @review.save
      respond_to do |format|
        format.html { redirect_to @course, success: 'Review added' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @review, success: 'Can not create review' }
        format.js
      end
    end
  end

  def update
    load_course
    load_review
    respond_to do |format|
      @review.update_attributes(review_params)
      format.json { respond_with_bip(@review) }
    end
  end

  def destroy
    load_course
    load_review
    @review.destroy
    respond_to do |format|
      format.html { redirect_to @course, success: 'Review deleted' }
      format.js
    end
  end

  def upvote
    load_single_review
    @upvoted = current_user.likes?(@review)
    if @upvoted
      current_user.unlike(@review)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.like(@review)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def downvote
    load_single_review
    @downvoted = current_user.dislikes?(@review)
    if @downvoted
      current_user.undislike(@review)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.dislike(@review)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

private

  def load_course
    @course = Course.friendly.find(params["course_id"])
  end

  def load_review
    @review ||= review_scope.find(params[:id])
  end

  def load_single_review
    @review ||= Review.find(params[:id])
  end

  def build_review
    @review ||= review_scope.build
    @review.attributes = review_params
  end

  def review_params
    review_params = params[:review]
    review_params ? review_params.permit(:body, :rating, :course_id) : {}
  end

  def review_scope
    @course.reviews.where(nil)
  end
end
