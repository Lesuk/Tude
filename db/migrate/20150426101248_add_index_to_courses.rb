class AddIndexToCourses < ActiveRecord::Migration
  def change
    add_index :enrollments, [:course_id, :user_id], unique: true
    change_column_null :enrollments, :course_id, false
    change_column_null :enrollments, :user_id, false
  end
end
