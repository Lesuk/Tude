class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category, counter_cache: true
  belongs_to :course
  has_many :comments, as: :commentable
  has_many :article_views
  has_many :favorites, as: :favorable
  has_many :fans, through: :favorites, source: :user

  scope :published, -> {where(status: true)}
  scope :draft, -> {where(status: false)}
  scope :order_desc, -> {order(id: :desc)}
  scope :popular, -> {order(article_views_count: :desc)}

  def user_fan?(user_id)
    self.fans.where(id: user_id).present?
  end
end
