class AddViewsCountToArticlesAndCourseAndUsers < ActiveRecord::Migration
  def change
    add_column :articles, :views_count, :integer, default: 0, null: false
    add_column :courses, :views_count, :integer, default: 0, null: false
    add_column :users, :views_count, :integer, default: 0, null: false
  end
end
