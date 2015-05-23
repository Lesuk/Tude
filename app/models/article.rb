require 'babosa'
class Article < ActiveRecord::Base
  belongs_to :user # author
  belongs_to :category, counter_cache: true
  belongs_to :section, touch: true
  belongs_to :course, counter_cache: true
  has_many :comments, as: :commentable
  has_many :views, as: :viewable
  #has_many :favorites, as: :favorable
  #has_many :fans, through: :favorites, source: :user
  has_many :article_progresses, dependent: :destroy
  has_many :completing_students, through: :article_progresses, source: :student
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  validates :slug, presence: true

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  acts_as_list scope: :course

  delegate :name, :whois, :bio, to: :user, prefix: true, allow_nil: true
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
      category = Category.friendly.find_by_slug(cat)
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

  # def user_fan?(user_id)
  #   self.fans.where(id: user_id).present?
  # end
end
