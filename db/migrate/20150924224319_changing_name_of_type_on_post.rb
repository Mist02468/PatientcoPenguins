class ChangingNameOfTypeOnPost < ActiveRecord::Migration
  def change
  	rename_column :posts, :type, :kind
  end
end
