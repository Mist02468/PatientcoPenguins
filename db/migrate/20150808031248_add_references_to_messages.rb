class AddReferencesToMessages < ActiveRecord::Migration
  def change
	add_column :messages, :sender_id, :integer
	add_column :messages, :recipient_id, :integer
    add_foreign_key :messages, column: :sender_id
    add_foreign_key :messages, column: :recipient_id
  end
end
