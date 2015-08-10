class User < ActiveRecord::Base
	has_many :posts
	has_many :messages
	has_and_belongs_to_many :events
	has_and_belongs_to_many :tags
	has_many :userSubscriptions, class_name: "User", foreign_key: "subscribingUser_id"
	belongs_to :subscribingUser, class_name: "User"
end
