class EnrollmentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    course = Course.find(params[:enrollment][:course_id])
    current_user.enroll!(course.id)
    redirect_to article_path(course.articles.first)
  end

  def destroy
    # course = Enrollments.find(params[:id]).course
    course = Course.find(params[:enrollment][:course_id])
    current_user.disenroll!(course.id)
    redirect_to course
  end
end
