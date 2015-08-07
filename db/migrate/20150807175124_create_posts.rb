class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
	  t.integer :type, default: 0
	  t.text :text
	  #need to add reference to user, once the migration creating the user table is run
      t.integer :voteCount, default: 0
      t.timestamps null: false
      #need to add references to tags and comments (which are posts)
    end
  end
end
