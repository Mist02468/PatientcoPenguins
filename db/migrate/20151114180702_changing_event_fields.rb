class ChangingEventFields < ActiveRecord::Migration
  def change
    rename_column :events, :hangout_link, :hangout_view_link
    add_column :events, :hangout_start_link, :string
    add_column :events, :hangout_join_link, :string
  end
end
