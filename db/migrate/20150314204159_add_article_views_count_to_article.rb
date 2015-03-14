class AddArticleViewsCountToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :article_views_count, :integer, default: 0, null: false
  end
end
