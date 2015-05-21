class Enrollment < ActiveRecord::Base

  enum status: [:active, :completed, :canceled]

  belongs_to :user
  belongs_to :course, counter_cache: :users_count

  validates_presence_of [:user_id, :course_id]
  validates_uniqueness_of :user_id, scope: :course_id, message: "can only register once per course"

  def track_completion(user, course_id)
    course = Course.find(course_id)
    Activity.track_activity(user, user.id, 'completed', course)
  end

end
