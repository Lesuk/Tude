class RemoveCourseIdAndParametersFromActivity < ActiveRecord::Migration
  def change
    remove_column :activities, :course_id, :integer
    remove_column :activities, :parameters, :text
  end
end
