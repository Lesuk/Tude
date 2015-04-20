class RenameStudentsCountToUsersCountInCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :students_count, :users_count
  end
end
