class User < ActiveRecord::Base
	has_many :posts
	has_many :messages
	has_and_belongs_to_many :events
	has_and_belongs_to_many :tags
	has_many :user_subscriptions, class_name: "UserSubscription", foreign_key: "subscriber_id", dependent: :destroy
	has_many :users_subscribing, class_name: "UserSubscription", foreign_key: "subscribed_id", dependent: :destroy
	has_many :subscribing_to, through: :user_subscriptions, source: :subscribed
	has_many :subscribers, through: :users_subscribing, source: :subscriber
end
