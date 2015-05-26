class RenameDescriptionInCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :description, :body
  end
end
