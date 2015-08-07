class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
	  #need to add references to users, the sender and receiver
	  t.string :subject
	  t.text :text
      t.timestamps null: false
    end
  end
end
