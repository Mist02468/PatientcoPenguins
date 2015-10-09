class AddColumnsSavingDocAndHangoutIds < ActiveRecord::Migration
  def change
	add_column :events, :doc_link, :string
	add_column :events, :hangout_link, :string
  end
end
