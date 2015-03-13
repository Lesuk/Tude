class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string "title"
      t.string "description"
      t.text "body"
      t.integer "course_id", index: true
      t.integer "category_id", index: true
      t.integer "user_id", index: true
      t.string "slug", index: true, unique: true
      t.timestamps null: false
    end
  end
end
