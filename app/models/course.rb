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
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions
  has_many :activities

  validates :slug, presence: true
  validates :level, inclusion: {in: LEVELS, message: "must be: easy/middle/hard"}

  after_touch :update_duration
  after_save :push_into_soulmate
  before_destroy :remove_from_soulmate

  searchkick highlight: [:title, :body]
  extend FriendlyId
  friendly_id :title, use: :slugged

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :name, :whois, to: :author, prefix: true, allow_nil: true

  scope :order_desc, -> { order(id: :desc) }
  scope :order_popular, -> { order(views_count: :desc) }
  scope :in_array, -> (ids) { where(id: ids) }

  def self.in_category(cat = nil)
    if cat.present?
      category = Category.friendly.find(cat)
      if category.parent?
        ids = category.subcategories.ids
        where(category_id: ids)
      else
        where(category_id: category.id)
      end
    else
      all
    end
  end

  def self.in_level(level = nil)
    level.present? ? where(level: level) : all
  end

  def self.search_courses(params)
    query = params[:q].presence || "*"
    conditions = {}
    conditions[:category_id] = Category.with_child_ids(params[:category]) if params[:category]
    conditions[:level] = params[:level] if ( params[:level] && Course::LEVELS.include?(params[:level]) )
    page_size = params[:pagesize] ? params[:pagesize] : 8
    highlight_settings = {fields: {title: {number_of_fragments: 0}, body: {fragment_size: 200}}}
    Course.search(
      query,
      include: [:category, :author],
      fields: ["title^10", "body"],
      highlight: highlight_settings,
      where: conditions,
      page: params[:page],
      per_page: page_size
    )
  end

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

  # Index only published courses
  # def should_index?
  #   # published?
  # end

 private

  def update_duration
    self.duration = self.sections.sum(:duration)
    self.save!
  end

  def push_into_soulmate
    loader = Soulmate::Loader.new("courses")
    loader.add("id" => self.id, "term" => self.title, "data" => {
      "url" => Rails.application.routes.url_helpers.course_path(self)
      })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("courses")
    loader.remove("id" => self.id)
  end
end
