class RenameYoutubeLinkInArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :youtube_link, :youtube_id
  end
end
