class SubscriptionsController < ApplicationController

  before_action :authenticate_user!

  add_breadcrumb("Edut", '/')

  def index
    users = current_user.subscribed_users.select(:id, :fullname, :username)
    categories = current_user.subscribed_categories.select(:id, :name, :slug)
    courses = current_user.subscribed_courses.select(:id, :title, :slug)
    articles = current_user.subscribed_articles.select(:id, :title, :slug)
    # questions = current_user.subscribed_questions.select(:id, :title, :slug)
    add_breadcrumb("Subscriptions", nil)
    render locals: {users: users, categories: categories, courses: courses, articles: articles}
  end

  def toggle
    load_subscribable
    @subscription = current_user.subscriptions.find_or_initialize_by(subscribable: @subscribable)
    if @subscription.new_record?
      @subscription.save
      track_activity(current_user, 'subscribe', @subscribable, @subscribable.id) if @subscription.subscribable_type == "User"
    else
      @subscription.destroy
    end
    respond_to do |format|
      format.js
      format.html { redirect_to @subscribable }
    end
  end

private

  def load_subscribable
    allowed = ["Category", "Course", "Article", "Question", "User"]
    resource, id = params[:subscribable_type], params[:subscribable_id]
    if allowed.include?(resource)
      @subscribable = resource.singularize.classify.constantize.find(id)
    end
  end
end
