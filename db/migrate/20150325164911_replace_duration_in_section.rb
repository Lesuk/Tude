class ReplaceDurationInSection < ActiveRecord::Migration
  def change
    remove_column :sections, :duration, :integer
    add_column :sections, :duration, :integer, default: 0, null: false
  end
end
