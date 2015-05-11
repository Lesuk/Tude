class AddParentToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :parent_type, :string
    add_column :activities, :parent_id, :integer
    add_index :activities, [:parent_id, :parent_type]
  end
end
