class RenamingTablesToBeStandard < ActiveRecord::Migration
  def change
	rename_table :tags_on_post, :posts_tags
	rename_table :user_tag_subscriptions, :tags_users
	rename_table :users_attending_event, :events_users
  end
end
