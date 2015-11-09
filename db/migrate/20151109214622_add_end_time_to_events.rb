class AddEndTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :endTime, :datetime
  end
end
