class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.belongs_to :mentionable, polymorphic: true
      t.integer :user_id
      t.timestamps null: false
    end
    add_index :mentions, [:mentionable_type, :mentionable_id]
    add_index :mentions, :user_id
  end
end
