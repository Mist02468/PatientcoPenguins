class CreateUserSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_subscriptions do |t|
      t.integer :subscriber_id
      t.integer :subscribed_id
      t.timestamps null: false
    end
    add_index :user_subscriptions, :subscriber_id
    add_index :user_subscriptions, :subscribed_id
    add_index :user_subscriptions, [:subscriber_id, :subscribed_id], unique: true
    remove_column :users, :subscribingUser_id
  end
end
