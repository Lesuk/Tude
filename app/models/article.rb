require 'babosa'
class Article < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :category
  belongs_to :section, touch: true
  belongs_to :course
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :article_progresses, dependent: :destroy
  has_many :completing_students, through: :article_progresses, source: :student
  has_many :subscriptions, as: :subscribable, dependent: :destroy
  has_many :subscribers, through: :subscriptions
  ##has_many :favorites, as: :favorable
  ##has_many :fans, through: :favorites, source: :user

  validates :slug, presence: true

  after_save :push_into_soulmate
  before_destroy :remove_from_soulmate

  searchkick highlight: [:title, :body]
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  acts_as_list scope: :course

  # Article.counter_culture_fix_counts :only => :category
  counter_culture :author, column_name: Proc.new { |model| model.published? ? 'articles_count' : nil },
                    :column_names => { ["articles.status = 1"] => 'articles_count' }
  counter_culture :course, :column_name => Proc.new {|model| model.published? ? 'articles_count' : nil },
                    :column_names => { ["articles.status = 1"] => 'articles_count' }
  counter_culture :category, :column_name => Proc.new {|model| model.published? ? 'articles_count' : nil },
                    :foreign_key_values => Proc.new {|category_id| [category_id, Category.find_by_id(category_id).try(:parent).try(:id)] }

  delegate :name, :whois, :bio, to: :author, prefix: true, allow_nil: true
  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :title, to: :course, prefix: true, allow_nil: true

  scope :published, -> {where(status: true)}
  scope :draft, -> {where(status: false)}
  scope :order_desc, -> {order(id: :desc)}
  scope :order_popular, -> {order(views_count: :desc)}
  scope :order_position, -> {order(position: :asc)} # 'articles.position ASC'
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

  def self.top_sorted_array(category)
    ids = self.top(count: 1000).map{ |a| a.id }
    articles = self.includes(:category).in_array(ids).published.in_category(category)
    articles = articles.sort_by{ |x| ids.index x.id }
  end

  def self.search_articles(params)
    query = params[:q].presence || "*"
    conditions = {}
    conditions[:category_id] = Category.with_child_ids(params[:category]) if params[:category]
    # conditions[:language] = params[:locale]
    page_size = params[:pagesize] ? params[:pagesize] : 8
    highlight_settings = {fields: {title: {number_of_fragments: 0}, body: {fragment_size: 200}}}
    Article.search(
      query,
      include: [:category, :author],
      fields: ["title^10", "description", "body"],
      highlight: highlight_settings,
      where: conditions,
      page: params[:page],
      per_page: page_size
    )
  end

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def normalize_friendly_id(string)
    string.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end

  def published?
    self.status == '1'
  end

  # Index only published articles
  def should_index?
    published?
  end

  # def user_fan?(user_id)
  #   self.fans.where(id: user_id).present?
  # end

 private

  def push_into_soulmate
    loader = Soulmate::Loader.new("articles")
    loader.add("id" => self.id, "term" => self.title, "data" => {
      "url" => Rails.application.routes.url_helpers.article_path(self)
      })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("articles")
    loader.remove("id" => self.id)
  end
end
