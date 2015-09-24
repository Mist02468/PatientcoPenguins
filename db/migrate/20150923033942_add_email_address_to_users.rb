class AddEmailAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :emailAddress, :string
  end
end
