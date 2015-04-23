class AddSlugsToTables < ActiveRecord::Migration
  def change
    add_column :articles, :slug, :string, null: false
    add_column :courses, :slug, :string, null: false
    add_column :categories, :slug, :string, null: false
  end
end
