class AddStatusToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :status, :integer, default: 0, null: false
  end
end
