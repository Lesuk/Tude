class RemoveSlugsFromAll < ActiveRecord::Migration
  def change
    remove_column :articles, :slug, :string
    remove_column :courses, :slug, :string
    remove_column :categories, :slug, :string
  end
end
