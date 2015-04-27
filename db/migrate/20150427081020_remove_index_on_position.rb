class RemoveIndexOnPosition < ActiveRecord::Migration
  def change
    remove_index :articles, :position if index_exists?(:articles, :position)
  end
end
