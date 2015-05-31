class AddCountColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :courses_count, :integer, default: 0, null: false
    add_column :users, :articles_count, :integer, default: 0, null: false
    add_column :users, :comments_count, :integer, default: 0, null: false
    add_column :users, :questions_count, :integer, default: 0, null: false
    add_column :users, :answers_count, :integer, default: 0, null: false
    add_column :users, :subscribers_count, :integer, default: 0, null: false
  end
end
