class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true
      t.references :favorable, polymorphic: true, index: true
      t.timestamps null: false
    end
    add_index :favorites, [:user_id, :favorable_id, :favorable_type], unique: true
  end
end
