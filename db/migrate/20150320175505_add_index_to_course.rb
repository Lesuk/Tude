class AddIndexToCourse < ActiveRecord::Migration
  def change
    add_index :courses, :user_id
  end
end
