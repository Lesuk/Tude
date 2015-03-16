class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string "name"
      t.string "description"
      t.string "slug", index: true, unique: true
      t.integer "parent_id", index: true, null: true
      t.integer "articles_count", default: 0, null: false
      t.integer "courses_count", default: 0, null: false
      t.timestamps null: false
    end
  end
end
