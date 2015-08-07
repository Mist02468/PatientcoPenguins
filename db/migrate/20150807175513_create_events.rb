class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
	  t.string :topic
	  t.datetime :startTime
	  #need to add references to the users who will attend
	  #need to add fields to hold Google links
      t.timestamps null: false
    end
  end
end
