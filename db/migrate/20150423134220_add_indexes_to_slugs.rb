class AddIndexesToSlugs < ActiveRecord::Migration
  def change
    remove_index :articles, :slug if index_exists?(:articles, :slug)
    remove_index :courses, :slug if index_exists?(:courses, :slug)
    remove_index :categories, :slug if index_exists?(:categories, :slug)
    add_index :articles, :slug, unique: true
    add_index :courses, :slug, unique: true
    add_index :categories, :slug, unique: true
  end
end
