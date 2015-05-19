class SubscriptionsController < ApplicationController

  def toggle
    load_subscribable
    @subscription = current_user.subscriptions.find_or_initialize_by(subscribable: @subscribable)
    if @subscription.new_record?
      @subscription.save
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
