class EnrollmentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    course = Course.find(params[:enrollment][:course_id])
    current_user.enroll!(course.id)
    redirect_to article_path(course.articles.first)
  end

  def destroy
    @course_enr = Enrollments.find(params[:id])
    current_user.disenroll!(@course_enr.id)
    respond_to do |format|
      format.html { redirect_to @course_enr }
      format.js
    end
  end
end
