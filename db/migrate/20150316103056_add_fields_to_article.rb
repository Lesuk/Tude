class AddFieldsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :section_id, :integer
    add_column :articles, :youtube_link, :string
    add_column :articles, :comments_count, :integer, default: 0, null: false
    add_column :articles, :status, :string, default: 0, null: false
    add_column :articles, :video_duration, :integer, default: 0, null: false
    add_column :articles, :demo_link, :string
    add_column :articles, :github_link, :string
    add_index :articles, :section_id
  end
end
