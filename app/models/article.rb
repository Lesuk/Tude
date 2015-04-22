class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category, counter_cache: true
  belongs_to :section, touch: true
  belongs_to :course, counter_cache: true
  has_many :comments, as: :commentable
  has_many :article_views
  #has_many :favorites, as: :favorable
  #has_many :fans, through: :favorites, source: :user

  scope :published, -> {where(status: true)}
  scope :draft, -> {where(status: false)}
  scope :order_desc, -> {order(id: :desc)}
  scope :order_popular, -> {order(article_views_count: :desc)}
  scope :in_array, ->(ids) { where(id: ids) }

  delegate :name, :whois, :bio, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :title, to: :course, prefix: true, allow_nil: true

  def self.in_category(cat_id = nil)
    if cat_id.present?
      category = Category.find(cat_id)
      if category.parent?
        ids = category.subcategories.ids
        where(category_id: ids)
      else
        where(category_id: cat_id)
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

  # def user_fan?(user_id)
  #   self.fans.where(id: user_id).present?
  # end
end
