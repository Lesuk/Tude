class AddRatingToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :rating, :float, default: 0.0, null: false
  end
end
