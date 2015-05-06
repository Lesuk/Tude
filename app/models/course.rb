require 'babosa'
class Course < ActiveRecord::Base

  LEVELS = ['easy', 'middle', 'hard']

  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :category, counter_cache: true
  has_many :sections, -> { order(position: :asc) }
  has_many :articles, through: :sections
  has_many :different_articles, through: :sections, source: :different_articles
  has_many :reviews, -> { published }
  has_many :enrollments
  has_many :users, through: :enrollments
  has_many :views, as: :viewable

  validates :slug, presence: true
  validates :level, inclusion: {in: LEVELS, message: "must be: easy/middle/hard"}

  after_touch :update_duration

  extend FriendlyId
  friendly_id :title, use: :slugged

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :name, :whois, to: :author, prefix: true, allow_nil: true

  scope :order_popular, -> { order(views_count: :desc) }

  def user_progress(user)
    course_articles_ids_array = self.course_articles_ids
    passed_articles_ids_array = user.passed_articles_ids
    passed_course_articles_ids_array = course_articles_ids_array & passed_articles_ids_array

    percentage = ( ( passed_course_articles_ids_array.size.to_f / course_articles_ids_array.size.to_f ) * 100 ).ceil

    {passed_articles_ids: passed_articles_ids_array, course_articles_ids: course_articles_ids_array,
      passed_course_articles_ids: passed_course_articles_ids_array, percentage: percentage}
  end

  def continue_course_article(user)
    progress = self.user_progress(user)
    not_completed_articles_ids = progress[:course_articles_ids] - progress[:passed_articles_ids]
    if not_completed_articles_ids.any?
      Article.find(not_completed_articles_ids[0])
    else
      self.articles.first
    end
  end

  def course_articles_ids
    self.articles.ids
  end

  def normalize_friendly_id(string)
    string.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end

 private

  def update_duration
    self.duration = self.sections.sum(:duration)
    self.save!
  end
end
