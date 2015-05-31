class AddSubscribersCountToCoursesAndArticles < ActiveRecord::Migration
  def change
    add_column :courses, :subscribers_count, :integer, default: 0, null: false
    add_column :articles, :subscribers_count, :integer, default: 0, null: false
    add_column :categories, :subscribers_count, :integer, default: 0, null: false
  end
end
