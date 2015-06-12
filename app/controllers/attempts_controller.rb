class AttemptsController < ApplicationController

  helper 'surveys'

  before_action :authenticate_user!
  before_action :normalize_attempts_data, only: [:create]
  after_action :record_user_view, only: [:new]

  add_breadcrumb("Edut", '/')

  def show
    load_quiz
    load_full_attempt
    add_breadcrumbs(["Quizzes", quizzes_path], [@quiz.name, nil])
    redirect_to quizzes_path, alert: 'You do not have permission for this action' if current_user.id != @attempt.participant_id
  end

  def new
    load_full_quiz
    @attempt = @quiz.attempts.new
    @attempt.answers.build
    add_breadcrumbs(["Quizzes", quizzes_path], [@quiz.name, nil])
  end

  def create
    load_quiz
    @attempt = @quiz.attempts.new(attempt_params)
    @attempt.participant = current_user

    if @attempt.valid? && @attempt.save
      redirect_to quiz_attempt_path(@quiz.id, @attempt.id), notice: "You passed the test! The results are shown below"
    else
      render :new
    end
  end

  def delete_user_attempts
    Survey::Attempt.where(participant_id: current_user.id, survey_id: params[:survey_id]).destroy_all
    redirect_to new_quiz_attempt_path(quiz_id: params[:survey_id])
  end

 private

  def load_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def load_full_quiz
    @quiz = Quiz.includes({questions: :options}).find(params[:quiz_id])
  end

  def load_full_attempt
    @attempt = Survey::Attempt.includes({answers: {question: :options}}).find_by(id: params[:id])
  end

  def normalize_attempts_data
    normalize_data!(params[:survey_attempt][:answers_attributes])
  end

  def normalize_data!(hash)
    multiple_answers = []
    last_key = hash.keys.last.to_i

    hash.keys.each do |k|
      if hash[k]['option_id'].is_a?(Array)
        if hash[k]['option_id'].size == 1
          hash[k]['option_id'] = hash[k]['option_id'][0]
          next
        else
          multiple_answers <<  k if hash[k]['option_id'].size > 1
        end
      end
    end

    multiple_answers.each do |k|
      hash[k]['option_id'][1..-1].each do |o|
        last_key += 1
        hash[last_key.to_s] = hash[k].merge('option_id' => o)
      end
      hash[k]['option_id'] = hash[k]['option_id'].first
    end
  end

  def attempt_params
    params.require(:survey_attempt).permit(Survey::Attempt::AccessibleAttributes)
  end

  def record_user_view
    View.set_view(@quiz, request.remote_ip)
  end
end
