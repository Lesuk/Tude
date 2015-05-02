module CoursesHelper

  def course_level(level)
  end

  def percent_passed_course(passed, all)
    ( ( passed.to_f / all.to_f ) * 100 ).ceil
  end

  def rating_to_percentage(rating)
    ( ( rating / 5.0 ) * 100 ).ceil
  end

end
