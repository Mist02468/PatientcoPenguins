class CreateReports < ActiveRecord::Migration
  def change
    remove_index(:user_subscriptions, name: "index_user_subscriptions_on_subscribed_id")
    remove_index(:user_subscriptions, name: "index_user_subscriptions_on_subscriber_id_and_subscribed_id")
    remove_index(:user_subscriptions, name: "index_user_subscriptions_on_subscriber_id")

    rename_table :user_subscriptions, :user_reports
    rename_column :user_reports, :subscriber_id, :reporter_id
    rename_column :user_reports, :subscribed_id, :reported_id
    add_column :user_reports, :message, :text
  end
end
