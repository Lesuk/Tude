class AddPositionToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :position, :integer, null: false
  end
end
