class MakeRequiredFieldsNullFalse < ActiveRecord::Migration
  def change
    change_column_null :events, :topic, false
    change_column_null :events, :startTime, false
    change_column_null :events, :host_id, false
    change_column_null :events, :doc_link, false
    change_column_null :events, :hangout_link, false
    
    change_column_null :posts, :kind, false
    change_column_null :posts, :text, false
    change_column_null :posts, :voteCount, false
    change_column_null :posts, :user_id, false
    
    change_column_null :tags, :name, false
  end
end
