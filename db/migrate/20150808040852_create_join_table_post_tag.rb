class CreateJoinTablePostTag < ActiveRecord::Migration
  def change
    create_join_table :posts, :tags, table_name: :tags_on_post do |t|
      # t.index [:post_id, :tag_id]
      # t.index [:tag_id, :post_id]
    end
    add_column :posts, :originatingPost_id, :integer
    add_foreign_key :posts, :originatingPost_id
  end
end
