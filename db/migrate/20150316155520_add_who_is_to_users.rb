class AddWhoIsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :whois, :string
  end
end
