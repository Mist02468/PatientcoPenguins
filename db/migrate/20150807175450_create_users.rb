class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	  #need to add references to subscriptions (tags or users)
	  #need to decide exactly which fields we want to get from LinkedIn, these are just for starters
	  t.string :firstName
	  t.string :lastName
	  t.string :location
	  t.integer :industry
	  t.integer :numConnections
	  t.string :position
	  t.string :company
	  t.integer :reportedCount
      t.timestamps null: false
    end
  end
end
