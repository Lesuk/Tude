class RemoveAuthorIdFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :author_id
    add_column :courses, :user_id, :integer, index: true
  end
end
