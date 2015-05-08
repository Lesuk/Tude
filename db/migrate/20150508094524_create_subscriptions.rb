class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id, index: true, null: false
      t.references :subscribable, polymorphic: true, index: true, null: false
      t.timestamps null: false
    end
  end
end
