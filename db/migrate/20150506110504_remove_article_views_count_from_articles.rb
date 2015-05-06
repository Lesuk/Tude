class RemoveArticleViewsCountFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :article_views_count, :integer
  end
end
