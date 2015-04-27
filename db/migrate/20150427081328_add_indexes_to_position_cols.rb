class AddIndexesToPositionCols < ActiveRecord::Migration
  def change
    add_index :articles, :position
    add_index :sections, :position
  end
end
