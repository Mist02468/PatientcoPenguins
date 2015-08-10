class CreateJoinTableUserTag < ActiveRecord::Migration
  def change
    create_join_table :users, :tags, table_name: :user_tag_subscriptions do |t|
      # t.index [:user_id, :tag_id]
      # t.index [:tag_id, :user_id]
    end
    add_column :users, :subscribingUser_id, :integer
    add_foreign_key :users, :subscribingUser_id
  end
end
