class CreateArticleViews < ActiveRecord::Migration
  def change
    create_table :article_views do |t|
      t.string :guest_ip
      t.integer :article_id

      t.timestamps null: false
    end
    add_index :article_views, :article_id
  end
end
