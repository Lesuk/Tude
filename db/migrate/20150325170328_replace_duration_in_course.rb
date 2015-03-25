class ReplaceDurationInCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :duration, :integer
    add_column :courses, :duration, :integer, default: 0, null: false
  end
end
