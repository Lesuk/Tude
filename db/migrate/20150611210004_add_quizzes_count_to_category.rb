class AddQuizzesCountToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :quizzes_count, :integer, default: 0, null: false
  end
end
