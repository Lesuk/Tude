class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string "title"
      t.string "summary"
      t.text "description"
      t.string "slug"
      t.text "content"
      t.string "level"
      t.integer "duration"
      t.string "youtube_id"
      t.integer "author_id", index: true
      t.integer "category_id", index: true
      t.integer "students_count", default: 0, null: false
      t.integer "articles_count", default: 0, null: false
      t.integer "reviews_count", default: 0, null: false
      t.timestamps null: false
    end
     add_index :courses, :slug, :unique => true
  end
end
