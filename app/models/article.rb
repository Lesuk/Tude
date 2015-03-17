class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category, counter_cache: true
  has_many :article_views
  has_many :favorites, as: :favorable
  has_many :fans, through: :favorites, source: :user

  scope :published, -> {where(status: true)}
  scope :draft, -> {where(status: false)}
  scope :order_desc, -> {order(id: :desc)}
  scope :popular, -> {order(article_views_count: :desc)}
end
