class ChangeStartLinkToActualStartTime < ActiveRecord::Migration
  def change
    rename_column :events, :hangout_start_link, :actualStartTime
    change_column :events, :actualStartTime, :datetime
  end
end
