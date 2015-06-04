class AddReviewsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reviews_count, :integer, default: 0, null: false
  end
end
