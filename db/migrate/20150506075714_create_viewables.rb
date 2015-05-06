class CreateViewables < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.references :viewable, polymorphic: true, index: true
      t.string :guest_ip
      t.timestamps null: false
    end
  end
end
