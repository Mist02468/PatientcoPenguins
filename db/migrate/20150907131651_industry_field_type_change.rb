class IndustryFieldTypeChange < ActiveRecord::Migration
  def change
	change_column :users, :industry, :string
  end
end
