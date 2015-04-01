class User < ActiveRecord::Base

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  has_many :articles
  has_many :comments
  has_many :own_courses, class_name: "Course"
  has_many :favorites
  has_many :favorite_articles, through: :favorites, source: :favorable, source_type: 'Article'
  has_many :enrollments
  has_many :courses, through: :enrollments

  validates :username, presence: true, uniqueness: {case_sensitive: false}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def name
    self.fullname.present? ? self.fullname : self.username
  end

  def to_param
    username
  end

  def enroll!(course_id)
    self.enrollments.create!(course_id: course_id)
  end

  def enrolled?(course_id)
    self.enrollments.find_by(course_id: course_id)
  end

  def disenroll!(course_id)
    self.enrollments.find_by(course_id: course_id).destroy!
  end
end
