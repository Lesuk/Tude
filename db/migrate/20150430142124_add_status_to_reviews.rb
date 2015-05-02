class AddStatusToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :status, :integer, default: 0, null: false
  end
end
