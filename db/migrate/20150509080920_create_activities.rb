class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :trackable, polymorphic: true, index: true
      t.integer :owner_id, null: false, index: true
      t.integer :recipient_id, index: true
      t.integer :course_id, index: true
      t.integer :category_id, index: true
      t.string :key
      t.text :parameters
      t.timestamps null: false
    end
  end
end
