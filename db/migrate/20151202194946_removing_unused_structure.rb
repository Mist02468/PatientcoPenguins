class RemovingUnusedStructure < ActiveRecord::Migration
  def change
    drop_join_table :events, :users
    remove_column :posts, :voteCount, :integer
    drop_join_table :tags, :users
  end
end
