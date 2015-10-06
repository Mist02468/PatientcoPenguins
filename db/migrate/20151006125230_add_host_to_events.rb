class AddHostToEvents < ActiveRecord::Migration
  def change
	add_reference :events, :host, index: true
    add_foreign_key :events, :users
  end
end
