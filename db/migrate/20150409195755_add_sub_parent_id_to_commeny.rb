class AddSubParentIdToCommeny < ActiveRecord::Migration
  def change
    add_column :comments, :subparent_id, :integer
    add_index :comments, :subparent_id
  end
end
