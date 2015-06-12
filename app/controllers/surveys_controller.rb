# Quizzes Controller (aka 'surveys')
class SurveysController < ApplicationController
  before_action :authenticate_user!, except: [:index, :popular]

  add_breadcrumb("Edut", '/')

  [:index, :popular, :favorites].each do |action|
    define_method action do
      quizzes ||= method("load_#{action}_quizzes".to_sym).call
      add_breadcrumb("Quizzes", nil)
      render :index, locals: {quizzes: quizzes}
    end
  end

  def new
    build_quiz
  end

  def create
    build_quiz
    save_quiz(true) or render 'new'
  end

  def edit
    load_quiz
  end

  def update
    load_quiz
    if @quiz.update_attributes(quiz_params)
      flash_message :success, 'Quiz updated'
      default_redirect
    else
      flash_message :danger, "Can't update"
      render :edit
    end
  end

  def destroy
    load_quiz
    @quiz.destroy
    default_redirect
  end

  def favorite
    load_quiz
    @favorited = current_user.bookmarks?(@quiz)
    if @favorited
      current_user.unbookmark(@quiz)
      destroy_activity(current_user, 'favorited', @quiz)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.bookmark(@quiz)
      track_activity(current_user, 'favorited', @quiz)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

 private

  def default_redirect
    redirect_to quizzes_path, alert: I18n.t("surveys_controller.#{action_name}")
  end

  def load_index_quizzes
    quiz_scope.includes(:category).active.order_desc
  end

  def load_popular_quizzes
    quiz_scope.includes(:category).active.order_popular
  end

  def load_favorites_quizzes
    current_user.bookmarked_quizzes.includes(:category).active.order_desc
  end

  def load_quiz
    @quiz = quiz_scope.find(params[:id])
  end

  def build_quiz
    @quiz ||= quiz_scope.build
    @quiz.attributes = quiz_params
  end

  def save_quiz(track = false)
    if @quiz.save
      track_activity(@quiz, 'create') if track
      default_redirect
    end
  end

  def quiz_params
    quiz_params = params[:quiz]
    quiz_params ? quiz_params.permit(Survey::Survey::AccessibleAttributes << :testable_type << :testable_id << :category_id) : {}
    # params.require(:survey_survey).permit(Survey::Survey::AccessibleAttributes << :testable_type << :testable_id << :category_id)
  end

  def quiz_scope
    Quiz.where(nil)
  end
end
