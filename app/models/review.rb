class Review < ActiveRecord::Base

  enum status: [:published, :spam]

  belongs_to :course
  belongs_to :user

  validates :course_id, :user_id, :body, :rating, :progress, presence: true
  validates_uniqueness_of :user_id, scope: :course_id, message: "can only once review course"
  validates :rating, numericality: {only_integer: true, greater_than_or_equal_to: 1,
                      less_than_or_equal_to: 5, message: "must be in range of 1 and 5"}
  validates :progress, numericality: {greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 100, message: "must be in range of 0 and 100"}

  before_validation :check_enrollment, on: :create
  before_validation :set_user_progress, on: :create
  after_save :update_course_rating
  after_destroy :update_course_rating

  counter_culture :course, column_name: Proc.new { |model| model.published? ? 'reviews_count' : nil }

  delegate :name, :username, :whois, :id, to: :user, prefix: true, allow_nil: true

  private

  def update_course_rating
    sum = Review.where("course_id = ? AND status = ?", self.course_id, Review.statuses[:published]).sum(:rating)
    size = Review.where("course_id = ? AND status = ?", self.course_id, Review.statuses[:published]).count
    rating = (sum.to_f / size.to_f).round(1)
    self.course.rating = rating
    self.course.save
  end

  def set_user_progress
    progress = self.course.user_progress(self.user)
    self.progress = progress[:percentage]
  end

  def check_enrollment
    self.user.enrolled?(self.course_id)
  end
end
