class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :course_id, null: false
      t.integer :user_id, null: false
      t.text :body, null: false
      t.integer :rating, default: 5, null: false
      t.integer :progress, default: 0, null: false
      t.timestamps null: false
    end
    add_index :reviews, [:course_id, :user_id], unique: true
    add_index :reviews, :course_id
    add_index :reviews, :user_id
  end
end
