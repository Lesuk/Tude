class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course, counter_cache: :users_count

  validates_presence_of [:user_id, :course_id]
  validates_uniqueness_of :user_id, scope: :course_id, message: "can only register once per course"
end
