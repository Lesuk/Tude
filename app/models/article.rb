class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :category, counter_cache: true
  has_many :article_views
end
