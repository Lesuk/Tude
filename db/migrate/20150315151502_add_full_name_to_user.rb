class AddFullNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :fullname, :string
    add_column :users, :bio, :text, limit: 600
  end
end
