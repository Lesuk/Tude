class AddIndexForPositionInArticle < ActiveRecord::Migration
  def change
    add_index :articles, :position, unique: true
  end
end
