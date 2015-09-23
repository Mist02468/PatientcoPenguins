class AddLinkedInIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedInId, :string
  end
end
