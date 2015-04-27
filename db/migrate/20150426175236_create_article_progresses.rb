class CreateArticleProgresses < ActiveRecord::Migration
  def change
    create_table :article_progresses do |t|
      t.integer "student_id", null: false
      t.integer "article_id", null: false
      t.timestamps null: false
    end
    add_index :article_progresses, :student_id
    add_index :article_progresses, :article_id
    add_index :article_progresses, [:student_id, :article_id], unique: true
  end
end
