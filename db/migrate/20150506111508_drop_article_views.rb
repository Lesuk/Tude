class DropArticleViews < ActiveRecord::Migration
  def change
    drop_table :article_views
  end
end
